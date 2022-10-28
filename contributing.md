## Notes on setting up to build locally on OSX

#### One time install
```
mkdir sphinx-setup
cd sphinx-setup
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh 
chmod +x Miniconda3-latest-MacOSX-x86_64.sh
./Miniconda3-latest-MacOSX-x86_64.sh -b -p ./miniconda3
```

#### Repeat at start of shell session
```
cd sphinx-setup
. miniconda3/bin/activate
conda create -n orcd-sphinx python=3.10
conda activate orcd-sphinx
```

#### To add sphinx software (one time)
```
cd sphinx-setup
. miniconda3/bin/activate
conda activate orcd-sphinx
conda install -c conda-forge sphinx sphinx_rtd_theme sphinx-panels
```

#### To build docs
```
cd sphinx-setup
. miniconda3/bin/activate
conda activate orcd-sphinx
cd ../orcd-docs-edit-git
sphinx-build -E . _build
```

