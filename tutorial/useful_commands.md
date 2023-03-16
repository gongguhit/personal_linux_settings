## python env config

### Mac

- English
Co
source ~/.bash_profile 
conda create --name nlp python=3.6
source ~/.bash_profile
conda activate nlp
pip install spacy
conda install tensorflow
conda install -c pandas
conda install -c jupyter
pip install textacy
conda install pytorch torchvision -c pytorch

    ```
- Chinese

    ```bash
    pip install jieba
    pip install snownlp
    pip install thulac
    pip install pyhanlp
    conda install -c conda-forge jpypel
    pip install pyhanlp
    pip install pynlpir

    ```


## Git Usage
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


### Pytorch GPU with conda

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

### server ssh config

1. 快速登录ssh-config

client `~/.ssh/config`:

```bash
Host gg306
    HostName <PUBLIC_IP>
    # HostName 111.11.3.1 私网IP
    User root
```

connect after config

```bash
ssh gg306
```

2. 免密登录

本地的`~/.ssh/id_rsa.pub`登记到远程的`~/.ssh/authorized_keys`

```bash
```

### Docker

##
nvidia cuda image:
https://hub.docker.com/r/nvidia/cuda

```bash

```

### Virtual env

create virtual env

```bash



```

start a venv



## Emacs usage

### Why Emacs

Esc Meta Alt Ctrl Shift



