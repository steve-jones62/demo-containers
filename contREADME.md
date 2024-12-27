## Readme for Containers

## Building Images

Each image is built from the base folder.  The following arguments should be used:
* BASE_FOLDER = The color and tier of the application (blue_web, green_db)

## GitLab Container Operations

GitLab CI will build all 4 containers when a push is done.  These containers will be saved in the registry on GitLab.  This link will take you to them:  https://gitlab.com/ignw1/customers/usbank/demo_code/container_registry

### Secrets information to access the containers from this repo

1)  Start with creating a deployment token `repo -> Settings -> Repository -> Deploy Tokens`
1)  Copy and save this username and token into [Google secrets manager](https://console.cloud.google.com/security/secret-manager?project=availability-zones-poc) as `demo_code_registry`
1)  Base 64 encode the {username:deploy_token}:  `echo demo_code_registry:K39deploytoken9Mrx | base64` this will be your `encoded key`
1)  Save your encoded key into the Google secrets manager as `encoded_key`
1)  Build a `.dockerconfigjson` file in the following format

```
{
    "auths": {
        "https://registry.gitlab.com":{
            "auth":"insert encoded_key from above"
    	}
    }
}
```

6)  Base64 encode this entire file: `cat .dockerconfigjson | base64`
1)  Save this value into [Google secrets manager](https://console.cloud.google.com/security/secret-manager?project=availability-zones-poc) as `encoded_dockerconfigjson` notice there is no `.` in the name.  this is due to google secrets manager restrictions on secret names.

### Running GitLab containers locally

To run the GitLab containers locally you need to do two things:

* Login to GitLab with Docker

```
docker login registry.gitlab.com -u {username} -p {api_key}
```

* Run the container(s) based on dev, test, or prod

```
docker run -p 9999:9999 registry.gitlab.com/ignw1/customers/usbank/demo_code:blue_web_dev
docker run -p 8888:8888 registry.gitlab.com/ignw1/customers/usbank/demo_code:blue_db_dev
docker run -p 9999:9999 registry.gitlab.com/ignw1/customers/usbank/demo_code:green_web_test
docker run -p 8888:8888 registry.gitlab.com/ignw1/customers/usbank/demo_code:green_db_prod
````

**EXAMPLE** (API key below will not work)
```
docker login registry.gitlab.com -u tigelane -p 3tcFA7WVi96S1ngrmfQN
docker run -p 9999:9999 registry.gitlab.com/ignw1/customers/usbank/demo_code:green_web_605fc578
```


## Local Container Operations

### Full build of all four containers locally

Use --no-cache or not depending on your circumstances.
```
docker build --no-cache -f Dockerfile_web -t blue_container_web:latest --build-arg BASE_FOLDER="blue_web" .
docker build --no-cache -f Dockerfile_db -t blue_container_db:latest --build-arg BASE_FOLDER="blue_db" .

docker build --no-cache -f Dockerfile_web -t green_container_web:latest --build-arg BASE_FOLDER="green_web" .
docker build --no-cache -f Dockerfile_db -t green_container_db:latest --build-arg BASE_FOLDER="green_db" .
```

### Run containers after building locally

```
docker run -p 9999:9999 blue_container_web:latest
docker run -p 8888:8888 blue_container_db:latest
docker run -p 9999:9999 green_container_web:latest
docker run -p 8888:8888 green_container_db:latest
````


### Target for Packer Image with initially TF OS deployment

### Responds to containerdb.usabanklab.com API - Therefore, requires this server to be running before use!
The vmdb.usbanklab.com server is a headless Flask server fronting a Redis DB image.  
The v1 API calls are:  
    add record to customer database use containerdb.usbanklab.com:8888/api/v1/entry  
    display last 10 records of customer database use containerdb.usbanklab.com:8888/api/v1/view10  
    display last 25 records of customer database use containerdb.usbanklab.com:8888/api/v1/view25  
    display last 50 records of customer database use containerdb.usbanklab.com:8888/api/v1/view50  
    dump customer database and rebuild empty use containerdb.usbanklab.com:8888/api/v1/dump  
