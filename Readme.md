az login

terraform init

terraform plan -var-file="terraform.tfvars"

terraform apply -var-file="terraform.tfvars" -auto-approve

terraform output


![alt text](./Screenshots/image-0.png)

![alt text](./Screenshots/image-1.png)

![alt text](./Screenshots/image-2.png)

![alt text](./Screenshots/image-3.png)

![alt text](./Screenshots/image-4.png)

![alt text](./Screenshots/image-5.png)

![alt text](./Screenshots/image-6.png)

![alt text](./Screenshots/image-7.png)

![alt text](./Screenshots/image-8.png)

az network nic show --name nic-myvm --resource-group CIS624-week6 --output table


az network nic show --name nic-myvm --resource-group CIS624-week6 --query "ipConfigurations[0].privateIpAddress" --output tsv

![alt text](./Screenshots/image-9.png)


# Verifying Subnet Association
az network nic show --name nic-myvm --resource-group CIS624-week6 --query "ipConfigurations[0].subnet.id" --output tsv

![alt text](./Screenshots/image-10.png)


terraform show | grep -A 10 "azurerm_network_interface"
![alt text](./Screenshots/image-11.png)


![alt text](./Screenshots/image-12.png)

![alt text](./Screenshots/image-13.png)


![alt text](./Screenshots/image-14.png)

![alt text](./Screenshots/image-15.png)


![alt text](./Screenshots/image-16.png)

![alt text](./Screenshots/image-17.png)


