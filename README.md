In this post, we will explore using Jupyter notebook as a development
environment for DevOps for AWS. We will use an example of developing a
mechanism to save 70% of the cost notebook instances in SageMaker,
using automatic stop and start at the end and beginning start of every
working day. Since the Jupyter notebooks are used interactively during
the working hours, stopping them and stopping to pay for them during
the nights and the weekends can save about 70% of the costs. We can
ask our data scientists or DevOps tools to shut them manually when
they leave the office or don't need them, but they won't. We will use
the following flow:
- A CloudWatch Scheduled Event called OnDuty that is triggered every
  working morning
- A Lambda function that is checking for notebook instances with a tag
  InDuty=Yes and starting them
- A CloudWatch Scheduled Event called OffDuty that is triggered every
  working evening - The same Lambda function stoping the InDuty
  instances

We will be using a Jupyter notebook to develop the above Lambda
function and the Terraform scripts to create the above environment. In
AllCloud we have a lot of DevOps code and a lot of infrastructures to
manage, and we found it hard to collaborate with the teams, team
members and our customers. Since Python is also the most common
language of our development, using Jupyter notebook as a development
environment allow us to share internally and externally easier.
