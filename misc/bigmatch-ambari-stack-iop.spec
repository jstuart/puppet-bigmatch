%define ambari_server_resource_base /var/lib/ambari-server/resources
%define bigmatch_service_base /stacks/BigInsights/4.0/services/BIGMATCH

Name:		bigmatch-ambari-stack-iop
Version:	11.4.0.3
Release:	2%{?dist}
Summary:	IBM Big Match Ambari Stack for IOP

Group:		Applications/Engineering
License:	IBM International Program License Agreement for Infosphere Big Match for Hadoop
URL:		http://www-03.ibm.com/software/products/en/infosphere-big-match-for-hadoop
Source0:	com.ibm.mdm.bigmatch.ambari.service-%{version}-iop-distrib.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:      noarch

#BuildRequires:	
Requires:	ambari-server >= 1.7.0

%description
Package that installs the IBM Big Match meta information into the Ambari IOP Stack.

%prep
%setup -q -c

%install
rm -rf %{buildroot}
%__install -m 0755 -d %{buildroot}%{ambari_server_resource_base}
%__cp -R -p stacks %{buildroot}%{ambari_server_resource_base}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{ambari_server_resource_base}%{bigmatch_service_base}
%doc


%changelog
* Thu Jul 2 2015 - James Stuart <james@stuart.name> 11.4.0.3-2
- Require ambari-server

* Thu Jul 2 2015 - James Stuart <james@stuart.name> 11.4.0.3-1
- Initial packaging
