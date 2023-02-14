# Azure DevOps Automation

[![MIT Licensed](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](./LICENSE)
[![Powered by Modus_Create](https://img.shields.io/badge/powered_by-Modus_Create-blue.svg?longCache=true&style=flat&logo=data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMzIwIDMwMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cGF0aCBkPSJNOTguODI0IDE0OS40OThjMCAxMi41Ny0yLjM1NiAyNC41ODItNi42MzcgMzUuNjM3LTQ5LjEtMjQuODEtODIuNzc1LTc1LjY5Mi04Mi43NzUtMTM0LjQ2IDAtMTcuNzgyIDMuMDkxLTM0LjgzOCA4Ljc0OS01MC42NzVhMTQ5LjUzNSAxNDkuNTM1IDAgMCAxIDQxLjEyNCAxMS4wNDYgMTA3Ljg3NyAxMDcuODc3IDAgMCAwLTcuNTIgMzkuNjI4YzAgMzYuODQyIDE4LjQyMyA2OS4zNiA0Ni41NDQgODguOTAzLjMyNiAzLjI2NS41MTUgNi41Ny41MTUgOS45MjF6TTY3LjgyIDE1LjAxOGM0OS4xIDI0LjgxMSA4Mi43NjggNzUuNzExIDgyLjc2OCAxMzQuNDggMCA4My4xNjgtNjcuNDIgMTUwLjU4OC0xNTAuNTg4IDE1MC41ODh2LTQyLjM1M2M1OS43NzggMCAxMDguMjM1LTQ4LjQ1OSAxMDguMjM1LTEwOC4yMzUgMC0zNi44NS0xOC40My02OS4zOC00Ni41NjItODguOTI3YTk5Ljk0OSA5OS45NDkgMCAwIDEtLjQ5Ny05Ljg5NyA5OC41MTIgOTguNTEyIDAgMCAxIDYuNjQ0LTM1LjY1NnptMTU1LjI5MiAxODIuNzE4YzE3LjczNyAzNS41NTggNTQuNDUgNTkuOTk3IDk2Ljg4OCA1OS45OTd2NDIuMzUzYy02MS45NTUgMC0xMTUuMTYyLTM3LjQyLTEzOC4yOC05MC44ODZhMTU4LjgxMSAxNTguODExIDAgMCAwIDQxLjM5Mi0xMS40NjR6bS0xMC4yNi02My41ODlhOTguMjMyIDk4LjIzMiAwIDAgMS00My40MjggMTQuODg5QzE2OS42NTQgNzIuMjI0IDIyNy4zOSA4Ljk1IDMwMS44NDUuMDAzYzQuNzAxIDEzLjE1MiA3LjU5MyAyNy4xNiA4LjQ1IDQxLjcxNC01MC4xMzMgNC40Ni05MC40MzMgNDMuMDgtOTcuNDQzIDkyLjQzem01NC4yNzgtNjguMTA1YzEyLjc5NC04LjEyNyAyNy41NjctMTMuNDA3IDQzLjQ1Mi0xNC45MTEtLjI0NyA4Mi45NTctNjcuNTY3IDE1MC4xMzItMTUwLjU4MiAxNTAuMTMyLTIuODQ2IDAtNS42NzMtLjA4OC04LjQ4LS4yNDNhMTU5LjM3OCAxNTkuMzc4IDAgMCAwIDguMTk4LTQyLjExOGMuMDk0IDAgLjE4Ny4wMDguMjgyLjAwOCA1NC41NTcgMCA5OS42NjUtNDAuMzczIDEwNy4xMy05Mi44Njh6IiBmaWxsPSIjRkZGIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiLz4KPC9zdmc+)](https://moduscreate.com)

-   [Objective](#objective)
-   [Architecture-chart](#architecture-chart)
-   [How it works](#how-it-works)
-   [Tutorial](#installing-on-azure-devops)
-   [Important notes](#important-notes)
-   [Modus Create](#modus-create)
-   [Licensing](#licensing)

## Objective

### Calculate “Effort”
- Automatically sum “Product Backlog Item” field “Effort” and add the total to the field “Effort” on the respective “Feature”;  
- Automatically sum “Product Backlog Item” field “Effort” (state=“done”) and add the total number to a custom field called “Completed Effort” on the respective “Feature”;  
- Automatically calculate the Percentage effort concluded (done) and add the percentage number to a custom field called “Percentage Completed Effort” on the respective “Feature”;  

### Calculate “Start Date” and “End Date”
- Based on “interactions” assigned to “Product Backlog Items” update the parent’s feature “Start Date” and “Target Date”.  
- The “Start Date” will be the minimum iteration date and the “Target Date” will be the maximum iteration date.  
Example: If a “Feature“ has 3 “Product Backlog Items”, 2 “Product Backlog Items” assigned to “sprint 23.1.1“ and 1 “Product Backlog Items” assigned to “sprint 23.1.2“ the respective “Feature” will receive the following values: Start Date: 1/1/2023 and End Date: 1/14/2023.

## Architecture chart
![Architecture Chart](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/architecture-chart.png?raw=true)

## How it works

When you update a “Product Backlog Item” on Azure Boards a WebHook will automatically trigger an Azure Pipeline and a Bash process (stored on Git) will run, calculate and update the fields on Azure Boards. 
The bash process uses the “az boards“ client which calls the Azure DevOps API.

The fields on “Feature” will be updated a few seconds after saving the “Product Backlog Item” (as soon as the pipeline finishes running). The user must refresh the page to see the results after the update.
To avoid using unnecessary resources the script will run only when fields (effort, state or interation) are updated on “Product Backlog Items”.

## Installing on Azure Devops

### Permissions

To configure the process will be necessary “Administrative Access” to Azure Devops
- Basically we need permission to do the following actions:
  - Azure Boards - Full control over the resource
  - Make changes on “Project Configuration” (Add/Remove/Edit Interactions)
  - Customize the “Azure Board” (Organization Settings/Boards/Process) - If we can’t have administrative permissions on organization level, please create the fields as described on configuration (step number 2)
  - Create/Edit Service Connections
  - Create/Edit Service Hooks
  - Create/Edit Azure Pipelines
  - Create an Azure Personal Access Token


### Configuration

1.  Create the Interactions on Azure Devops based on the standards (Project Settings - Project Configuration)

![Step 1](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/1.png?raw=true)

2.  Customize the Azure Board adding the fields “Percentage Completed Effort” and “Completed Effort” on “features” and also a field called “ParentId” on “Product Backlog Item”;

![Step 2](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/2.png?raw=true)

3.  Create a library called devops_boards and make variable customizations based on client’s board configuration (you can also check devops_variables.sh);

![Step 3](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/3.png?raw=true)

4.  Create the pipelines using the yml files stored on Git (existing YAML pipeline file) and set the secret “AZURE_DEVOPS_EXT_PAT” on pipeline;

![Step 4](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/4.png?raw=true)

5.  Make sure you have ubuntu-latest agents available to run the pipeline;
    - Generate a Personal Access Token to be used by the agent  
    - If you are using self-hosted agent follow the instructions on Azure DevOps  
    - Make sure you have “az client” and “az board” installed on agent machine  

![Step 5](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/5.png?raw=true)

6.  Create the all Service Connections;

- incoming_webhook_connection_trigger_date
- incoming_webhook_connection_trigger_devops
- incoming_webhook_connection_trigger_effort

![Step 6](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/6.png?raw=true)

7.  Create the Service Hooks - You can use create_hook.txt as a template (Azure Devops won't accept creating multiple webhooks, so create one by one);

![Step 7](https://github.com/fernandomatsuosantos/az_devops/blob/main/docs/img/7.png?raw=true)

8.  Test the pipelines and webhook to make sure it’s working properly

## Important notes
- The process can run on “Azure Agents” or “Self-Hosted Agents” based on clients' needs. If the client runs software development pipelines on Azure DevOps we can create and use a small ubuntu Self-Hosted Agent machine to run the pipeline avoiding concurrency with development teams pipelines;
- The maximum expiration period for an Azure Personal Access Token is 1 year. Before the expiration date the Personal Access Token must be renewed on Azure Devops and updated at Aha! Integration, otherwise the integration will stop working.


## Modus Create

[Modus Create](https://moduscreate.com) is a digital product consultancy. We use a distributed team of the best talent in the world to offer a full suite of digital product design-build services; ranging from consumer facing apps, to digital migration, to agile development training, and business transformation.

<a href="https://moduscreate.com/?utm_source=labs&utm_medium=github&utm_campaign=Azure_DevOps"><img src="https://res.cloudinary.com/modus-labs/image/upload/h_80/v1533109874/modus/logo-long-black.svg" height="80" alt="Modus Create"/></a>
<br />

This project is part of [Modus Labs](https://labs.moduscreate.com/?utm_source=labs&utm_medium=github&utm_campaign=Azure_DevOps).

<a href="https://labs.moduscreate.com/?utm_source=labs&utm_medium=github&utm_campaign=Azure_DevOps"><img src="https://res.cloudinary.com/modus-labs/image/upload/h_80/v1531492623/labs/logo-black.svg" height="80" alt="Modus Labs"/></a>

## Licensing

This project is [MIT licensed](./LICENSE).

