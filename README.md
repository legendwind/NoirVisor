# NoirVisor
NoirVisor - Hardware-Accelerated Hypervisor solution with support to complex functions and purposes and nested virtualization.

# Introduction
NoirVisor is a hardware-accelerated hypervisor (a.k.a VMM, Virtual Machine Monitor) with support to complex functions and purposes. It is designed to support processors based on x86 architecture with hardware-accelerated virtualization feature. For example, Intel processors supporting Intel VT-x or AMD processors supporting AMD-V meet the requirement. By designation, NoirVisor determines the processor manufacturer and selects the function core.

# Processor Requirement
Intel Processors based on Intel 64 and IA-32 Architecture, with support to Intel VT-x. Intel EPT is prefered, but not required. <br>
AMD Processors based on AMD64 Architecture, with support to AMD-V. Nested Paging is prefered, but not required. <br>
Other processors based on x86 architecture may be supported in future. <br>
Currently, it is discovered that x86 processors produced by VIA, Zhaoxin and Hygon supports Hardware-Accelerated Virtualization Technology. In summary, certain facts are observed that:
- Processors produced by Intel Corporation may support Intel VT-x.
- Processors produced by Advanced Micro Devices Inc. may support AMD-V.
- Processors produced by VIA Technologies Inc. may support Intel VT-x.
- Processors produced by Shanghai Zhaoxin Semiconductor Co, Ltd. may support Intel VT-x.
- Processors produced by Chengdu Hygon Integrated Circuit Design Co, Ltd. may support AMD-V.

# Nested Virtualization
NoirVisor is developed in highest focus on nested virtualization. It is not currently supported, but will be developed in future. <br>
Algorithm regarding the Nested Virtualization was stated down in the readme files in VT-Core directory.

# Announcement to all contributors
NoirVisor is coded in the C programming language and the assembly since it is procedure-oriented designed. <br>
Contributing Guidelines are available in repository. For details, see the markdown file in the root directory of repository. <br>
DO NOT PROVIDE CODES WITH C++ WHICH INVOLVES THE NoirVisor Core IN YOUR PULL-REQUEST!

# Build
To build a kernel-mode driver on Windows, you should install Windows Driver Kit 7.1.0 to default path on C disk. Then run the provided batch file to build it. <br>
Also note that, you have to create certain directories required by the batch complilation. <br>
You may download the WDK 7.1.0 from Microsoft: https://www.microsoft.com/en-us/download/details.aspx?id=11800 <br>
Note that you should execute the build_prep.bat to make directories for first-time compilation. <br>
Presets for Free/Release build are available. Please note that the compiled binary under Free build does not come along with a digital signature. You might have to sign it yourself.

# Test
There is a .NET Framework 4.0 based GUI loader available on GitHub now: https://github.com/Zero-Tang/NoirVisorLoader <br>
If you are using operating systems older than Windows 8, you are supposed to manually install .NET Framework 4.0 or higher. <br>
If you use the digital signature provided in NoirVisor's repository, then you should enable the test-signing on your machine.

# Supported Platforms
NoirVisor is designed to be cross-platform. It can be built to a kernel-mode component of an operating system, or even as a software with bootstrap running on bare-metal. <br>
Currently, NoirVisor supports the Windows Operating System newer than or same as Windows XP, running as a kernel-mode driver. <br>
If there is already a hypervisor running in the system, make sure it supports native virtualization nesting.

# Development Status
Project NoirVisor has five future development plans: <br>
- Remaster CPUID-caching architecture with a flexible design. <br>
- Develop Nested Paging with Stealth Hook on SVM-Engine for NoirVisor. <br>
- Develop Nested Virtualization. <br>
- Develop Hypervisor-Platform compatible hypervisor for Windows 10 Redstone. <br>
- Port NoirVisor to 32-bit Windows platform.

# Completed Features
- Stealth SSDT Hook (NtOpenProcess Hook) on 64-bit Windows, both Intel VT-x and AMD-V.
- Stealth Inline Hook (NtSetInformationFile Hook) on 64-bit Windows, Intel VT-x.
- Tagged Translation Lookaside Buffer by ASID/VPID feature.
- CPUID caching architecture. (First Design, not quite efficient.)
- Critical Hypervisor Protection.
- Software-Level Code Integrity Enforcement.
- Hardware-Level Code Integrity Enforcement based on AMD-V NPT.

# License
This repository is under MIT license. <br>

# Code of Conduct
The Code of Conduct is added to NoirVisor Project since May.5th, 2019. Please follow rule when contributing.