# This code was brought and modified from https://github.com/hspark1212/MOFTransformer/
import os
import numpy as np
from pathlib import Path
from collections.abc import Iterable, Sequence
from itertools import product
from functools import wraps, partial
from matplotlib import pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib import animation
from PIL import Image, ImageSequence
import ase
import glob
from IPython.display import display

from matplotlib.animation import PillowWriter

from visualize.utils import (
    get_structure,
#    get_heatmap,
    scaler,
#    get_model_and_datamodule,
#    get_batch_from_index,
#    get_batch_from_cif_id,
)
from visualize.setting import (
    get_fig_ax,
    set_fig_ax,
    set_axes_equal,
    DEFAULT_FIGSIZE,
    DEFAULT_VIEW_INIT,
    get_default_cbar_kwargs,
#    get_cmap,
)
from visualize.drawer import (
    draw_cell,
    draw_atoms,
#    draw_heatmap_grid,
#    draw_colorbar,
#    draw_heatmap_graph,
)


class MOFVisualizer(object):
    def __init__(self, path_cif, heatmap_graph=None, heatmap_grid=None, uni_idx=None, **kwargs):
        """
        Attention Visualizer from "MOFTransformer model"
        :param path_cif: <str> path for original cif file.
        :param heatmap_graph: <np.array> graph attention score for cif
        :param heatmap_grid: <np.array> grid attention score for cif
        :param uni_idx: <list-> list> uni index for cif. (from model.utils.prepare_data)
        :param kwargs:
            figsize : (float, float) figure size
            view_init : (float, float) view init from matplotlib
            show_axis : <bool> If True, axis are visible. (default : False)
            show_colorbar : <bool> If True, colorbar are visible. (default : True)
            cmap : (str or matplotlib.colors.ListedColormap) color map used in figure. (default : None)
            num_patches : (int, int, int) number of patches (default : (6, 6, 6))
            max_length : <float> max p_lattice length of structure file (Å)
            min_length: <float> min p_lattice length of structure file (Å)
        """
        self.no_cif = False

        if path_cif == None:
            self.no_cif = True
            self.kwargs = kwargs

            # get primitive structure from cif
           
            self.p_atoms = ase.Atoms()
            self.p_lattice = np.array(
                                   [[ 1,  0,  0],
                                    [ 0,  1,  0],
                                    [ 0,  0,  2]])
            self.s_atoms = ase.Atoms()
            self.s_lattice = np.array(
                                   [[ 1,  0,  0],
                                    [ 0,  1,  0],
                                    [ 0,  0,  2]])
            self.kwargs = kwargs


        else:
            self.path_cif = path_cif
            self.heatmap_graph = heatmap_graph
            self.heatmap_grid = heatmap_grid
            self.uni_idx = uni_idx
            self.kwargs = kwargs
            self.cbar_kwargs = get_default_cbar_kwargs(self.figsize)

            # get primitive structure from cif
            p_atoms = get_structure(self.path_cif, make_supercell=False, dtype="ase")
            self.p_atoms = p_atoms
            self.p_lattice = p_atoms.cell.array

            # get supercell atoms from cif
            max_length, min_length = kwargs.get("max_length", 60), kwargs.get(
                "min_length", 30
            )
            super_atoms = get_structure(
                self.path_cif,
                make_supercell=True,
                dtype="ase",
                max_length=max_length,
                min_length=min_length,
            )
            self.s_atoms = super_atoms
            self.s_lattice = super_atoms.cell.array


    '''
    @classmethod
    def from_batch(cls, batch, batch_idx, model, cif_root, **kwargs):
        """
        Attention visualizer from "MOFTransformer" model and "dataloader batch"
        :param batch: Dataloader -> batch
        :param batch_idx: index for batch index
        :param model: <torch.model> fine-tuned MOFTransformer model
        :param cif_root: <str> root dir for cif files
        :param kwargs:
            figsize : (float, float) figure size
            view_init : (float, float) view init from matplotlib
            show_axis : <bool> If True, axis are visible. (default : False)
            show_colorbar : <bool> If True, colorbar are visible. (default : True)
            cmap : (str or matplotlib.colors.ListedColormap) color map used in figure. (default : None)
            num_patches : (int, int, int) number of patches (default : (6, 6, 6))
            max_length : <float> max p_lattice length of structure file (Å)
            min_length: <float> min p_lattice length of structure file (Å)
        :return: <PatchVisualizer> patch visualizer object
        """
        output = model.infer(batch)
        heatmap_graph, heatmap_grid = get_heatmap(output, batch_idx)
        uni_idx = batch["uni_idx"][batch_idx]
        cif_id = batch["cif_id"][batch_idx]
        path_cif = os.path.join(cif_root, cif_id + ".cif")
        return cls(
            path_cif, heatmap_graph, heatmap_grid, uni_idx, cif_id=cif_id, **kwargs
        )

    @classmethod
    def from_index(
        cls, index, model_path, data_root, downstream="", cif_root=None, **kwargs
    ):
        """
        Create PatchVisualizer from index. The index corresponds 1:1 to the MOF in the json file in dataset folder.
        The index matches the cif order of json.
        :param index: (int) index of dataset.
        :param model_path: (str) path of model from fine-tuned MOFTransformer with format '.ckpt'
        :param data_root: (str) path of dataset directory obtained from 'prepared_data.py. (see Dataset Preparation)
                MOFs to be visualized must exist in {dataset_folder}/test.json or {dataset_folder}/test_{downstream}.json,
                and {dataset_folder}/test folder. *.graphdata, *.grid, *.griddata16 files should be existed in {dataset_folder}/test folder.
        :param downstream: (str, optional) Use if data are existed in {dataset_folder}/test_{downstream}.json (default:'')
        :param cif_root: (str, optional) path of directory including cif file. The cif lists in the dataset folder should be included.
                If not specified, it is automatically specified as a {dataset_folder}/test folder.
        :param kwargs:
            figsize : (float, float) figure size
            view_init : (float, float) view init from matplotlib
            show_axis : <bool> If True, axis are visible. (default : False)
            show_colorbar : <bool> If True, colorbar are visible. (default : True)
            cmap : (str or matplotlib.colors.ListedColormap) color map used in figure. (default : None)
            num_patches : (int, int, int) number of patches (default : (6, 6, 6))
            max_length : <float> max p_lattice length of structure file (Å)
            min_length: <float> min p_lattice length of structure file (Å)
        :return: PatchVisualizer class for index
        """
        model, data_iter = get_model_and_datamodule(model_path, data_root, downstream)
        batch = get_batch_from_index(data_iter, index)
        if cif_root is None:
            cif_root = os.path.join(data_root, "test")

        return cls.from_batch(batch, 0, model, cif_root, **kwargs)

    @classmethod
    def from_cifname(
        cls, cifname, model_path, data_root, downstream="", cif_root=None, **kwargs
    ):
        """
        Create PatchVisualizer from cif name. cif must be in test.json or test_{downstream}.json.

        :param cifname : (str) name or path of cif. Data matching the corresponding cif name is retrieved from the dataset.
        :param model_path: (str) path of model from fine-tuned MOFTransformer with format '.ckpt'
        :param data_root: (str) path of dataset directory obtained from 'prepared_data.py. (see Dataset Preparation)
                MOFs to be visualized must exist in {dataset_folder}/test.json or {dataset_folder}/test_{downstream}.json,
                and {dataset_folder}/test folder. *.graphdata, *.grid, *.griddata16 files should be existed in {dataset_folder}/test folder.
        :param downstream: (str, optional) Use if data are existed in {dataset_folder}/test_{downstream}.json (default:'')
        :param cif_root: (str, optional) path of directory including cif file. The cif lists in the dataset folder should be included.
                If not specified, it is automatically specified as a {dataset_folder}/test folder.
        :param kwargs:
            figsize : (float, float) figure size
            view_init : (float, float) view init from matplotlib
            show_axis : <bool> If True, axis are visible. (default : False)
            show_colorbar : <bool> If True, colorbar are visible. (default : True)
            cmap : (str or matplotlib.colors.ListedColormap) color map used in figure. (default : None)
            num_patches : (int, int, int) number of patches (default : (6, 6, 6))
            max_length : <float> max p_lattice length of structure file (Å)
            min_length: <float> min p_lattice length of structure file (Å)
        :return: PatchVisualizer class for index
        """
        model, data_iter = get_model_and_datamodule(model_path, data_root, downstream)
        batch = get_batch_from_cif_id(data_iter, cifname)
        if cif_root is None:
            cif_root = os.path.join(data_root, "test")
        return cls.from_batch(batch, 0, model, cif_root, **kwargs)
    '''
    def __repr__(self):
        return f"class <PatchVisualizer> from {self.cif_id}"

    @property
    def cif_id(self):
        if cif_id := self.kwargs.get("cifname"):
            return cif_id
        else:
            return Path(self.path_cif).stem

    '''
    @property
    def cmap(self):
        return self.kwargs.get("cmap", None)

    @cmap.setter
    def cmap(self, cmap):
        if isinstance(cmap, (str, ListedColormap)) or cmap is None:
            self.kwargs["cmap"] = cmap
        else:
            raise TypeError(
                f"cmap must be str, ListedColormap, or None, not {type(cmap)}"
            )
    '''
            
    @property
    def num_patches(self):
        return self.kwargs.get("num_patches", (6, 6, 6))

    @property
    def figsize(self):
        return self.kwargs.get("figsize", DEFAULT_FIGSIZE)

    @figsize.setter
    def figsize(self, figsize):
        if not isinstance(figsize, Sequence):
            raise TypeError(f"figsize must be tuple or list, not {type(figsize)}")
        elif len(figsize) != 2:
            raise ValueError(f"figsize must be (float, float) not {figsize}")
        self.kwargs["figsize"] = figsize
        self._sync_cbar_kwargs()

    @property
    def view_init(self):
        return self.kwargs.get("view_init", DEFAULT_VIEW_INIT)

    @view_init.setter
    def view_init(self, view_init):
        if not isinstance(view_init, Sequence):
            raise TypeError(f"view_init must be tuple or list, not {type(view_init)}")
        elif len(view_init) != 2:
            raise ValueError(f"view_init must be (float, float) not {view_init}")
        self.kwargs["view_init"] = view_init

    @property
    def show_axis(self):
        return self.kwargs.get("show_colorbar", False)

    @show_axis.setter
    def show_axis(self, show_axis):
        if not isinstance(show_axis, bool):
            raise TypeError(f"show_axis must be bool, not {type(show_axis)}")
        self.kwargs["show_axis"] = show_axis

    @property
    def show_colorbar(self):
        return self.kwargs.get("show_colorbar", True)

    @show_colorbar.setter
    def show_colorbar(self, show_colorbar):
        if not isinstance(show_colorbar, bool):
            raise TypeError(f"show_colorbar must be bool, not {type(show_colorbar)}")
        self.kwargs["show_colorbar"] = show_colorbar

    @property
    def atomic_scale(self):
        return self.figsize[0] * self.figsize[1]

    def set_default(self):
        self.kwargs = {}
        self._sync_cbar_kwargs()

    def _sync_cbar_kwargs(self):
        figsize = self.figsize
        self.cbar_kwargs["labelpad"] = figsize[0] * 2
        self.cbar_kwargs["labelsize"] = figsize[0] * 1.5
        self.cbar_kwargs["fontsize"] = figsize[0]

    def _get_indice_inside_patch(self, patch_position, ep=0.0):
        def is_inside_patch(r_pos, pos_patch, num_patch):
            lower_bound = (pos_patch - ep) / num_patch < r_pos
            upper_bound = r_pos < (pos_patch + 1 + ep) / num_patch
            return np.logical_and(lower_bound, upper_bound)

        relative_position = self.s_atoms.get_scaled_positions()
        position_bools = [
            is_inside_patch(r_pos, pos_patch, num_patch)
            for r_pos, pos_patch, num_patch in zip(
                relative_position.T, patch_position, self.num_patches
            )
        ]  # x, y, z

        position_bool = np.logical_and.reduce(position_bools)  # total
        (indice,) = np.where(position_bool)
        return indice

    def _grid_attention_rank(self, rank):
        heatmap_grid = self.heatmap_grid
        sort = np.flip(
            np.unravel_index(np.argsort(heatmap_grid, axis=None), heatmap_grid.shape),
            axis=-1,
        )
        if isinstance(rank, int):
            return np.array(sort)[:, rank][np.newaxis, :]
        elif isinstance(rank, Iterable):
            return np.array(sort)[:, tuple(rank)].T
        else:
            raise TypeError(f"rank must be int or iterable, not {type(rank)}")

    def set_colorbar_options(self, default=False, **cbar_kwargs):
        if default:
            self.cbar_kwargs = get_default_cbar_kwargs(self.figsize)
        else:
            for key, value in cbar_kwargs.items():
                if key in self.cbar_kwargs:
                    self.cbar_kwargs[key] = value

    def draw_graph(
        self,
        minatt=0.000,
        maxatt=0.010,
        *,
        alpha=0.7,
        atomic_scale_factor=3,
        grid_scale_factor=0.75,
        #att_scale_factor=3,
        return_fig=False,
        savefile=None,
        **kwargs,
    ):
        """
        Draw graph attention score figure in primitive unit cell
        :param minatt: (float) Minimum value of attention score (default : 0.000). A value smaller than minatt is treated as minatt.
        :param maxatt: (float) Maximum value of attention score (default : 0.010). A value larger than maxatt is treated as maxatt.
        :param alpha: (float) The alpha blending value, between 0 (transparent) and 1 (opaque).
        :param atomic_scale_factor: (float) The factors that determines atom size. (default = 1)
        :param grid_scale_factor: (float) The factors that determines grid size (default = 3)
        :param att_scale_factor: (float) The factor that determines attention-score overlay size (default = 5)
        :param return_fig : (bool) If True, matplotlib.figure.Figure and matplotlib.Axes3DSubplot are returned.
        :param kwargs:
            view_init : (float, float) view init from matplotlib
            show_axis : <bool> If True, axis are visible. (default : False)
            show_colorbar : <bool> If True, colorbar are visible. (default : False)
            cmap : (str or matplotlib.colors.ListedColormap) color map used in figure. (default : None)
        """
        #heatmap_graph = self.heatmap_graph
        lattice = self.p_lattice
        atoms = self.p_atoms

        fig, ax = get_fig_ax(**self.kwargs)
        #cmap = get_cmap(kwargs.get("cmap", self.cmap))
        set_fig_ax(ax, **kwargs)

        if self.no_cif:
            draw_cell(ax, lattice, color="lightgrey")
        else:
            draw_cell(ax, lattice, color="black")

        draw_atoms(
            ax, atoms, self.atomic_scale * atomic_scale_factor * grid_scale_factor
        )

        # colors = cmap(scaler(heatmap_graph, minatt, maxatt))
        # atomic_scale = (
        #     self.atomic_scale
        #     * att_scale_factor
        #     * grid_scale_factor
        #     * atomic_scale_factor
        # )
        # draw_heatmap_graph(ax, atoms, self.uni_idx, colors, atomic_scale, alpha)

        # if kwargs.get("show_colorbar", self.show_colorbar):
        #     draw_colorbar(fig, ax, cmap, minatt, maxatt, **self.cbar_kwargs)

        set_axes_equal(ax, scale_factor=grid_scale_factor)

        if savefile != None:
            fig.savefig(savefile)

        if return_fig:
            return fig, ax
        else:
            plt.show()





def animate(func, frame=360, interval=20, savefile=None, fps=30):
    def turn(i, ax, fig, **kwargs):
        #view_init = kwargs.get("view_init", (0, 0))
        ax.view_init(elev=0, azim=i)
        return ax,

    def init():
        return ()

    @wraps(func)
    def wrapper(*args, **kwargs):
        kwargs["return_fig"] = True
        fig, ax = func(*args, **kwargs)
        anim = animation.FuncAnimation(
            fig,
            partial(turn, ax=ax, fig=fig, **kwargs),
            #init_func=init,
            frames=frame,
            interval=interval,
            blit=False,
        )
        if savefile:
            #anim.save(savefile, fps=fps, dpi=150)
            anim.save(savefile, writer=PillowWriter(fps=fps), dpi=150)

        plt.close()
        return anim

    return wrapper

def resize_gif(in_file, out_file, size=(300,200)):
    with Image.open(in_file) as im:
        frames = []
        for frame in ImageSequence.Iterator(im):
            frame = frame.resize(size)
            frames.append(frame)
    
        frames[0].save(out_file, save_all=True, append_images=frames[1:])
    return None

def make_concat_gif(cif_dir, gif_dir):

    cifs = glob.glob(f'{cif_dir}/*cif')

    # At most 6 cifs will be converted
    if len(cifs) > 6:
        cifs = cifs[:6]
    else:
        while len(cifs) < 6:
            cifs.append(None)

    gif_list = []

    for cif in cifs:
        if cif != None:
            cif_name = os.path.basename(cif)
        else:
            cif_name = 'empty'

        mof_gif_path = f'{gif_dir}/{cif_name}.gif'

        vis = MOFVisualizer(path_cif=cif)

        animate(func=vis.draw_graph, savefile=mof_gif_path)()

        mof_gif_small_path = f'{gif_dir}/{cif_name}_small.gif'

        # resize gif into (300,200)
        resize_gif(mof_gif_path, mof_gif_small_path)

        # remove old gif 
        os.system(f'rm {mof_gif_path}')
        #display(ipy_image(f'{mof_gif_small_path}'))

        gif_list.append(Image.open(mof_gif_small_path))


    frames = []
    # Iterate through each frame in the GIFs
    for frame1, frame2, frame3, frame4, frame5, frame6 in zip(ImageSequence.Iterator(gif_list[0]),
                                                                ImageSequence.Iterator(gif_list[1]),
                                                                ImageSequence.Iterator(gif_list[2]),
                                                                ImageSequence.Iterator(gif_list[3]),
                                                                ImageSequence.Iterator(gif_list[4]),
                                                                ImageSequence.Iterator(gif_list[5])):
        # Create a new blank image for each frame
        new_frame = Image.new('RGBA', (900, 400))

        # Paste each frame in its respective position
        new_frame.paste(frame1, (0, 0))
        new_frame.paste(frame2, (300, 0))
        new_frame.paste(frame3, (600, 0))
        new_frame.paste(frame4, (0, 200))
        new_frame.paste(frame5, (300, 200))
        new_frame.paste(frame6, (600, 200))

        # Append the combined frame to the list of frames
        frames.append(new_frame)

    frames[0].save(f'{gif_dir}/mof_concat.gif', save_all=True, append_images=frames[1:], loop=0, duration=gif_list[0].info['duration'])    