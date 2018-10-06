# Pangeo (HiMAT)

## Getting Started
1. Install [terraform](https://www.terraform.io/downloads.html), [jq](https://stedolan.github.io/jq/), [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html), [aws-cli](https://aws.amazon.com/cli/), and [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
2. Configure the AWS CLI if you have not already. Instructions can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
3. Modify `terraform.tfvars` as necessary
4. Run `terraform init`
5. Run `terraform apply --target=module.eks`
6. Run `terraform apply --target=module.kubernetes`

After following these steps, your cluster should be up and running. You should see two outputs, `jupyter_url` and `dask_url`. Visit `jupyter_url` to access the notebook server attached to the cluster, and `dask_url` to view information on dask jobs. Because containers in the cluster take time to set up, these links may not work for a minute or two. Make sure to include the port number when opening the urls in the browser.

## Scaling
To scale the number of nodes in the cluster, change, `spot_node_count` in `terraform.tfvars`, and run `terraform apply --target=module.eks` again.

## Hibernation
To shut down non-essential components of the cluster when not in use to save costs, set `hibernate` in `terraform.tfvars` to `true`, and run `terraform apply --target=module.eks`. To recreate these components when you would like to work with the cluster, set `hibernate` to `false`, and run `terraform apply --target=module.eks` again.

## Deletion
1. Run `terraform destroy --target=module.kubernetes`
2. Run `terraform destroy --target=module.eks`

## Customization

### Custom Packages
If you need to use some package not included in the default docker image, you can build a custom image using Docker.
1. Download and start [docker](https://docs.docker.com/install/)
2. Log in or create an account on Docker Cloud
3. Navigate to the `docker` folder
3. Modify `environment.yml` to include the packages you need
4. Run `docker build -t <docker-cloud-username>/<image-name>:latest .` to build your image locally. This process may take several minutes.
5. Run `docker push <docker-cloud-username>/<image-name>:latest` to upload your image
6. Change `worker_image` in `terraform.tfvars` to `<docker-cloud-username>/<image-name>:latest`
7. Deploy cluster as above

### Cluster Details
To customize basic cluster details, such as the cluster name and region, modify the corresponding values in `terraform.tfvars` (`cluster_name`, `cluster_region`). Make sure that the value you select for `cluster_region` is a valid AWS region.

### Machine Type
To customize the machine type of your nodes, modify the `stable_instance_type` and `spot_instance_type` in `terraform.tfvars`. `stable_instance_type` defines the type of machine that your Dask scheduler and notebook will run on, while `spot_instance_type` defines the type of machine that your Dask workers will run on. Ensure that these are valid AWS machine types. If you are modifying `stable_instance_type`, ensure that there is enough space on a single machine of type `stable_instance_type` to allocate all of the CPU and RAM required by your Dask scheduler and notebook (See Dask Configuration, Jupyter Configuration below). If you are modifying `spot_instance_type`, you should also modify `spot_price` correspondingly. All Dask workers run on [spot](https://aws.amazon.com/ec2/spot/) instances to lower costs, and `spot_price` defines the maximum price that your instances will be scheduled at. If you're unsure how to proceed, simply set `spot_price` to the on-demand price of your `spot_instance_type`.

### Cluster Size
To adjust the number of nodes in your cluster, modify `spot_node_count` in `terraform.tfvars`. This will determine the number of machines to allocate to Dask workers. A single machine of type `stable_instance_type` will always be allocated to the Dask scheduler and notebook server. If you set `spot_node_count` to 10, for instance, your cluster will consist of 11 machines, 10 of which contain Dask workers, and one of which contains the Dask scheduler and notebook server.

### Dask Configuration
To customize the configuration of both your Dask scheduler and pool of Dask workers, several variables are provided. `dask_worker_count` defines the number of Dask workers that your cluster will attempt to schedule. To ensure that the cluster is always making full use of its resources, it is helpful to set this to a large value (e.g. 100 or 1000) so that all capacity will be used. `dask_worker_milli_cpu`, `dask_scheduler_mb_ram`, `dask_worker_procs`, `dask_worker_threads` are provided to allow you to fine-tune the resources provided to your Dask workers. Similarly, `dask_scheduler_milli_cpu` and `dask_scheduler_mb_ram` are provided to allow you to fine-tune the resources provided to your Dask scheduler. The defaults values for these values should suffice in most cases. If you would like to modify these variables, take care to ensure that your Dask scheduler and notebook can still be scheduled on a single machine of type `stable_instance_type`.

### Jupyter Configuration
To customize the configuration of your Jupyter notebook, several variables are provided. `jupyter_milli_cpu` and `jupyter_mb_ram` function in the same way as the variables `dask_scheduler_milli_cpu` and `dask_worker_mb_ram` described above. As above, if you modify these variables, take care to ensure that your Dask scheduler and notebook can still be scheduled on a single machine of type `stable_instance_type`. `jupyter_gb_storage` is provided to enable you to define the amount of disk space given to your notebook.

## Cluster Layout
```
 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
│                                                                                       │
                                ╔═══════════════════════╗                                
│                               ║      Stable Node      ║                               │
                ╔════════════╗  ║                       ║                                
│               ║            ║  ║ ┌───────┐ ┌─────────┐ ║                               │
                ║ EBS Volume ║─┐║ │       │ │         │ ║                                
│               ║            ║ └─▶│Jupyter│ │Scheduler│ ║                               │
                ╚════════════╝  ║ │       │ │         │ ║                                
│                               ║ └───────┘ └─────────┘ ║                               │
                                ╚═══════════════════════╝                                
│                                           ▲                                           │
                ┌───────────────────────────┼───────────────────────────┐                
│ ┌ ─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ┐ │
    ╔═══════════════════════╗   ╔═══════════════════════╗   ╔═══════════════════════╗    
│ │ ║       Spot Node       ║   ║       Spot Node       ║   ║       Spot Node       ║ │ │
    ║                       ║   ║                       ║   ║                       ║    
│ │ ║ ┌──────┐     ┌──────┐ ║   ║ ┌──────┐     ┌──────┐ ║   ║ ┌──────┐     ┌──────┐ ║ │ │
    ║ │      │     │      │ ║◀─▶║ │      │     │      │ ║◀─▶║ │      │     │      │ ║    
│ │ ║ │Worker│ ... │Worker│ ║   ║ │Worker│ ... │Worker│ ║   ║ │Worker│ ... │Worker│ ║ │ │
    ║ │      │     │      │ ║   ║ │      │     │      │ ║   ║ │      │     │      │ ║    
│ │ ║ └──────┘     └──────┘ ║   ║ └──────┘     └──────┘ ║   ║ └──────┘     └──────┘ ║ │ │
    ╚═══════════════════════╝   ╚═══════════════════════╝   ╚═══════════════════════╝    
│ │                              Spot Autoscaling Group                               │ │
   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   
│                                          EKS                                          │
 ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
```
