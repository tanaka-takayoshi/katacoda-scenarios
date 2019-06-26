wget https://download.visualstudio.microsoft.com/download/pr/5e92f45b-384e-41b9-bf8d-c949684e20a1/67a98aa2a4e441245d6afe194bd79b9b/dotnet-sdk-2.2.300-linux-x64.tar.gz

mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-2.2.300-linux-x64.tar.gz -C $HOME/dotnet
export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet

cd ~