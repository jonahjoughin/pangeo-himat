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
## Deletion
1. Run `terraform destroy --target=module.kubernetes`
2. Run `terraform destroy --target=module.eks`

## Cluster Layout
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐

│                                 ╔═══════════════════════╗                                 │
                                  ║      Stable Node      ║                                  
│                                 ║                       ║                                 │
                                  ║ ┌───────┐ ┌─────────┐ ║                                  
│                                 ║ │       │ │         │ ║                                 │
                                  ║ │Jupyter│ │Scheduler│ ║                                  
│                                 ║ │       │ │         │ ║                                 │
                                  ║ └───────┘ └─────────┘ ║                                  
│                                 ╚═══════════════════════╝                                 │
                                              ▲                                              
│                ┌────────────────────────────┼────────────────────────────┐                │
   ┌ ─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─▼─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ▼ ─ ─ ─ ─ ─ ─ ┐   
│    ╔═══════════════════════╗    ╔═══════════════════════╗    ╔═══════════════════════╗    │
   │ ║       Spot Node       ║    ║       Spot Node       ║    ║       Spot Node       ║ │   
│    ║                       ║    ║                       ║    ║                       ║    │
   │ ║ ┌──────┐     ┌──────┐ ║    ║ ┌──────┐     ┌──────┐ ║    ║ ┌──────┐     ┌──────┐ ║ │   
│    ║ │      │     │      │ ║◀──▶║ │      │     │      │ ║◀──▶║ │      │     │      │ ║    │
   │ ║ │Worker│ ... │Worker│ ║    ║ │Worker│ ... │Worker│ ║    ║ │Worker│ ... │Worker│ ║ │   
│    ║ │      │     │      │ ║    ║ │      │     │      │ ║    ║ │      │     │      │ ║    │
   │ ║ └──────┘     └──────┘ ║    ║ └──────┘     └──────┘ ║    ║ └──────┘     └──────┘ ║ │   
│    ╚═══════════════════════╝    ╚═══════════════════════╝    ╚═══════════════════════╝    │
   │                               Spot Autoscaling Group                                │   
│   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │
                                             EKS                                             
└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
