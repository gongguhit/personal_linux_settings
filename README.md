# personal linux settings
> personal linux configurations user:gg

Helpful for setting up a new Linux workshop quickly.


## SSH config
1. quick login

client settings: `~/.ssh/config`:

```bash
Host gg306
    HostName <PUBLIC_IP>
    # HostName 111.11.3.1 private IP
    User root
```

connect after config

```bash
ssh gg306
```
2. Cloudflared client settings
```bash
# install cloudflared
sudo apt install cloudflared
# modify ssh config
vim ~/.ssh/config
# add
Host ssh.example.com
ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h
```
Then can connect with command
```bash
ssh <username>@ssh.example.com
```

## Git settings and usage
### git init config
```bash
git config --global user.name "gongguhit"
git config --global user.email gonggu95@gmail.com
ssh-keygen -t rsa -C "gongguhit@gmail.com"
```
```bash
ssh-agent -s
ssh-add ~/.ssh/id_rsa
# if error
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
```
github.com -> settings -> SSH keys -> new SSH key
copy id_rsa.pub into it.
```bash
# validate key
ssh -T git@github.com
```
### git local and remote sync

1. create directory and initialize repo
```bash
git init
```
2. Set connection to remote repo
```bash
# set connection
git remote add origin ${Remote Repo Path}

# check connection status
git remote -v

# delete connection
git remote rm origin ${Remote Repo Path}

```

3. commit code
```bash
# pull sync files
git pull origin main

# add files for upload
git add .

# commit
git commit -m "MESSAGE”

# push
git push origin main
```

4. Others

- Failed to push
```bash
git pull origin main --allow-unrelated-histories
```

```bash
# check file status
git status

# remove folders
git rm [file_name] -r -f
git commit -m 'del config'
git push origin main

# check log
git log

# change repo name
git branch -M main
```

## Development Env
### CUDA
Here for cuda 11.8 + cudnn 8.8.x

1. Install NVIDIA Driver 525

```bash
sudo apt update # optional but recommended
sudo apt upgrade # optional but recommended
sudo apt install nvidia-driver-525
```

check install satus

```bash
nvidia-smi
```

2. Install CUDA

download the installer, for ubuntu 22.04 it is

```bash
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run

# install
sudo sh cuda_11.8.0_520.61.05_linux.run
# accept, next screen unselect the older driver

# edit linked library, I change cuda to cuda-11.8
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# refresh environment
source ~/.bashrc

# ldconfig
sudo bash -c “echo /usr/local/cuda/lib64 > /etc/ld.so.conf.d/cuda.conf”
sudo ldconfig
# But I change it with following in ~/.bashrc
export LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH"
sudo ldconfig
# check ldconfig worked by
ldconfig -p | grep cuda


export LD_LIBRARY_PATH="/usr/local/cuda-11.7/lib64:$LD_LIBRARY_PATH"
```

Verify CUDA installation

```bash
cat /usr/local/cuda/version.json | grep version -B 2
# mine with cuda-11.8

# verify with cuda-samples
git clone https://github.com/NVIDIA/cuda-samples.git
cd cuda-samples/
sudo apt install libfreeimage-dev
make -j$(nproc) > compile.log 2>&1 &
tail -f compile.log
# check with demo
cd Samples/4_CUDA_Libraries/matrixMulCUBLAS
./matrixMulCUBLAS
# if multiple GPUs
cd ~/cuda-samples/Samples/5_Domain_Specific/p2pBandwidthLatencyTest
./p2pBandwidthLatencyTest
nvidia-smi nvlink -s
# clean up
rm -rf ~/cuda_11.8.0_520.61.05_linux.run ~/cuda-samples
```

3. CUDNN

Download page:

```
https://developer.nvidia.com/cudnn
```

Extract and unzip the file

```bash
tar -xvf data.tar.xz
cd var/cudnn-local-repo-ubuntu2204-8.8.0.121/
sudo dpkg -i libcudnn8_8.8.0.121-1+cuda11.8_amd64.deb
sudo dpkg -i libcudnn8-dev_8.8.0.121-1+cuda11.8_amd64.deb
sudo dpkg -i libcudnn8-samples_8.8.0.121-1+cuda11.8_amd64.deb
```

Verify installed by mninst

```bash
cat /usr/include/x86_64-linux-gnu/cudnn_version_v8.h | grep CUDNN_MAJOR -A 2

cd /usr/src/cudnn_samples_v8/mnistCUDNN
sudo make -j$(nproc)
./mnistCUDNN
```
### Docker

1. Installation and basic usage

A detailed Docker install and usage website: https://yeasy.gitbook.io/docker_practice/


2. some useful bug fixing and tips

- Permission denied after adding user group
```bash
sudo chmod a+rw /var/run/docker.sock
```
- Use gpu
```bash
# method 1 directly use compiled image
# list images
docker images
# remove images
docker rmi <IMAGE ID>
# run container
docker run --name ubuntu22 -idt nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
# check running container
docker ps
# run into container with bash
docker exec -it ubuntu22 /bin/bash

# method 2, map the system's cuda to docker env, you only need to add this argument
docker run --gpus all
```

### python env
#### Python package path

1. `$path_prefix/lib` standard lib path
2. `$path_prefix/lib/pythonX.Y/site-packages` site-packages path

You can use `echo` to print and check

Linux default: `$path_prefix` = `/usr` or `/usr/local`

```python
# some functions for find arguments
import sys
sys.executable
# path for search packages
sys.path
sys.prefix
```


#### Install Miniconda3

```bash
# Download miniconda3
cd ~
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sha256sum Miniconda3-latest-Linux-x86_64.sh
# Verify that the output matches the one online
sh Miniconda3-latest-Linux-x86_64.sh
#clean
rm ~/Miniconda3-latest-Linux-x86_64.sh
```

#### Virtual Env

You can also use `venv` for creating python environment.
```bash
# install venv
sudo pip install virtualenv
# make env folder
mkdir test && cd test
# create venv
virtualenv venv
```
Start a venv

```bash
source /test/venv/bin/activate
```
#### python packages

- NLP
```bash
# English
conda create --name nlp python=3.6
source ~/.bash_profile
conda activate nlp
pip install spacy
conda install tensorflow
conda install -c pandas
conda install -c jupyter
pip install textacy
conda install pytorch torchvision -c pytorch
# Chinese
pip install jieba
pip install snownlp
pip install thulac
pip install pyhanlp
conda install -c conda-forge jpypel
pip install pyhanlp
pip install pynlpir
```
- Pytorch

Manually install
```bash
# create env
conda create -n py38 python=3.8
# install dependencies
conda install astunparse numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclassesconda install -c pytorch magma-cuda118
# clone pytorch repo
git clone --recursive git@github.com:pytorch/pytorch.git
cd pytorch
# choose the desired version
git checkout v1.13.1
# begin to install
export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}
python setup.py install
# pillow and torchvision
# pillow
wget https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/2.1.5.1.tar.gz
tar -xzf 2.1.5.1.tar.gz
cd libjpeg-turbo-2.1.5.1/
sudo apt install yasm
# torchvision
git clone https://github.com/pytorch/vision.git
cd vision
# check one version and install
python
from setup import get_dist
get_dist('pillow')
git checkout v0.14.1
python setup.py install
```
## Editors
### Vim
#### Neovim

### Emacs
#### Why Emacs
- What is Emacs
  - Esc
  - Meta
  - Alt
  - Ctrl
  - Shift
