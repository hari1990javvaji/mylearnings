## Takehome Assignment
### Problem:

There is an empty AWS account with nothing deployed yet. The business is needing the infrastructure team to build and deploy two VPCs, from scratch using Terraform and peer both VPCs together.

**Acceptance Criteria:**

- Two VPCs are deployed, `VPC-A` and `VPC-B`
- Each VPC has public/private subnets and is highly available.  

- VPCs are able to talk to the internet.

- The public subnet in VPC-A is able to pass http/https traffic to the private subnet inside VPC-B.



**Notes:**
- Terraform code is that written should be production-ready, maintainable, extendable, and following best practices.

- All other implementation details are up to the infrasturcture team to determine.

- Return the assignment with your terraform code in a ZIP folder to your careernet representative