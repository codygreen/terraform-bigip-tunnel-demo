# BIG-IP Management Public IP Addresses
output "mgmtPublicIP" {
  value = toset([
    for device in module.bigip : device.mgmtPublicIP
  ])
}
# BIG-IP Management Public DNS Address
output "mgmtPublicDNS" {
  value = toset([
    for device in module.bigip : device.mgmtPublicDNS
  ])
}

# BIG-IP Management Port
output "mgmtPort" {
  value = toset([
    for device in module.bigip : device.mgmtPort
  ])
}

# BIG-IP Username
output "f5_username" {
  value = toset([
    for device in module.bigip : device.f5_username
  ])
}

# BIG-IP Password
output "bigip_password" {
  value = toset([
    for device in module.bigip : device.bigip_password
  ])
}
