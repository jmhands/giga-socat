FROM debian:12-slim

# Install essential tools and socat
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    ocl-icd-libopencl1 tzdata socat \ 
    && rm -rf /var/lib/apt/lists/*

# Set up the Chia Recompute working directory and copy files
WORKDIR /chia-recompute
COPY docker-start.sh chia_recompute* .

# Environment variables and exposed ports
ENV CHIA_RECOMPUTE_PORT="11989"
EXPOSE 11989

# Nvidia OpenCL setup
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Start socat to forward IPv6 to IPv4 and run the main script
CMD ["./docker-start.sh"]
