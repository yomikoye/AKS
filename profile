# set profile with: notepad $profile and paste below alias
# Refresh session with: . $profile | if it fails first run: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Set-Alias -Name k -Value kubectl

function GetPods([string]$namespace=”default”)
{
 kubectl get pods -n $namespace
}
Set-Alias -Name kgp -Value GetPods

function GetPodsWide([string]$namespace=”default”)
{
 kubectl get pods -n $namespace -o wide
}
Set-Alias -Name kgpw -Value GetPods

function GetAll([string]$namespace=”default”)
{
 kubectl get all -n $namespace
}
Set-Alias -Name kgall -Value GetAll

function GetNodes()
{
 kubectl get nodes -o wide
}
Set-Alias -Name kgn -Value GetNodes

function DescribePod([string]$container, [string]$namespace=”default”)
{
 kubectl describe pod $container -n $namespace
}
Set-Alias -Name kdp -Value DescribePod

function GetLogs([string]$container, [string]$namespace=”default”)
{
 kubectl logs pod/$container -n $namespace
}
Set-Alias -Name klp -Value GetLogs
