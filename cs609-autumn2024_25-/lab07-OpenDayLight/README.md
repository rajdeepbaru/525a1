<h2 align="center" style="border-bottom: 5px dotted">
   <p> Software-Defined Networking and Network Function Virtualization (CS-609)</p>
    <p> Autumn 2024-25, Indian Institute of Technology Dharwad </p>
    <p> Lab Worksheet 07, Tuesday morning session, 29th October 2024 </p>
    

</h2>

<h2 align="center" style="border-bottom: 5px dotted">
   <p> Topic covered: OpenDaylight </p>
    

</h2>




# Installation



1. You may use the following link: https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/distribution-karaf/0.6.3-Carbon

2. Extract it using: `tar -xvzf karaf-0.21.0.tar.gz`

3. Change to the directory `cd karaf-0.6.3/`

4.  Make sure to install openjdk-8.

5. To run the karaf distribition, execute `./bin/karaf`


<img src="Screenshot from 2024-10-29 06-02-21.png" >


# Install the Karaf features

To install a feature, use the following command, where feature1 is the feature name listed in the table below:

`feature:install <feature1>`

You can install multiple features using the following command:

`feature:install <feature1> <feature2> ... <featureN-name>`



# Listing available features

To find the complete list of Karaf features, run the following command:

`feature:list`

To list the installed Karaf features, run the following command:

`feature:list -i`


