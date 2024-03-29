
#  Example Razor App with AzureAD Authentication, with AKS Deployment and Dockerfile

Example of Razor app, with AzureAD Authentication, to be deployed into a cluster with Application Gateway Ingress Controller

__NOTE:__  This example was deployed into AKS with a App Gateway Ingress controller addon enabled, and configured with ```cert-manager/lets encrypt``` to generate the frontend certs, and Azure DNS + ```external-dns``` for DNS resolution 



## Register your App With Azure AD

Register a ```web``` app following [this](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)

__NOTE:__ Set the AzureAD application RedirectURI to ```https://localhost:5000/signin-oidc```.And Update the ```Manifest``` with ```"allowPublicClient": true```


Update the ```ClientId``` and ```TenantId``` from your new AzureAD application in the ```appsettings.json``` file

## Build & Create Container

Create release files

```
dotnet publish -c Release
```

Set ```ACRNAME``` to your container registry that is integrated into AKS, and build your container

```
docker build -t ${ACRNAME}.azurecr.io/dotnet-demo:0.0.1 .

```


## Run Locally

docker run -d \
  -it \
  -p 5000:5000 \
  --name dotnet-demo \
  ${ACRNAME}.azurecr.io/dotnet-demo:0.0.1

## Deploy to ACR & kubernetes

Upload to ACR

```
 az acr login -n  ${ACRNAME}
 docker push ${ACRNAME}.azurecr.io/dotnet-demo:0.0.1
```


In the ```deployment.yml``` file replace the following values:

 * ```{{ACRNAME}}``` to your ACR name (ie ```myacr001```)
 * ```{{DNSZONE}}``` to ypur DNS zone (ie ```example.com```)


Deploy to AKS

```
 kubectl apply -f ./deployment.yml
```  

Add a new AzureAD application RedirectURI to ```https://dotnet-demo.{{DNSZONE}}/signin-oidc```.

Your new webapp should be accessable on ```https://dotnet-demo.{{DNSZONE}}```




### Intresting troubleshooting

https://stackoverflow.com/questions/48399699/azure-ad-redirect-url-using-application-gateway

https://github.com/AzureAD/microsoft-identity-web/issues/223

https://devblogs.microsoft.com/aspnet/forwarded-headers-middleware-updates-in-net-core-3-0-preview-6/
