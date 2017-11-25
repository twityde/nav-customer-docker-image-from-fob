# Dockerfile to Import FOB and create new Image based on Customer DB NAV Image

## How-To

- Build the first Image with [this](https://github.com/twityde/nav-customer-docker-image/) Dockerfile
- Clone the repository to your Docker host. 
- Place your FOB files in the custom\objects directory.
- Set the correct source docker image in the Dockerfile.
- Create the custom image with: `docker build -t sample/custom:new-version .`

## Issues

For any issues, please file under this GitHub project on the [Issues section](https://github.com/twityde/nav-customer-docker-image-from-fob/issues).

## Troubleshooting & Frequently Asked Questions

- Licensing for Microsoft Dynamics NAV: Regardless of where you run it - VM, Docker, physical, cloud, on prem - the licensing model is the same.
