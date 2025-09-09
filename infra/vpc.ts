const publicSubnet1 = new sst.Secret("PublicSubnet1");
const publicSubnet2 = new sst.Secret("PublicSubnet2");
const publicSubnet3 = new sst.Secret("PublicSubnet3");
const privateSubnet1 = new sst.Secret("PrivateSubnet1");
const privateSubnet2 = new sst.Secret("PrivateSubnet2");
const privateSubnet3 = new sst.Secret("PrivateSubnet3");
const securityGroup1 = new sst.Secret("SecurityGroup1");

export const vpc = new sst.Linkable("Vpc", {
  properties: {
    publicSubnets: [publicSubnet1.value, publicSubnet2.value, publicSubnet3.value],
    privateSubnets: [privateSubnet1.value, privateSubnet2.value, privateSubnet3.value],
    securityGroups: [securityGroup1.value],
  },
});
