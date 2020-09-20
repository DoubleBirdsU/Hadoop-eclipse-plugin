# Hadoop-eclipse-plugin-2.8.5

#### 项目介绍

在Windows下，编译时，需要安装 Ant，eclipse

@[TOC](编译 hadoop-eclipse-plugins-2.8.5.jar 文件)

不想自己编译可以到 [hadoop-eclipse-plugin](https://github.com/DoubleBirdsU/Hadoop-eclipse-plugin) 下载 **`hadoop-eclipse-plugin-2.8.5.jar`** 。

# 1、编译准备

编译之前首先需要安装 Ant 及 配置环境。

## 1.1. 安装Ant

1. 首先下载 Ant，例如下载版本：`apache-ant-1.10.5-bin.zip`，网上搜索。
2. 配置环境 

```bash
ANT_HOME=D:\Program Files (x86)\apache-ant-1.10.5
Path=Path;%ANT_HOME%\bin;
```

3. 验证安装、配置是否成功

```bash
ant -version
```

## 1.2. 下载安装Hadoop-2.8.5.tar.gz

解压 Hadoop-2.8.5.tar.gz，路径中不要包含空格。解压到 D:\hadoop-2.8.5

## 1.3. 下载安装 Eclipse

本文安装 eclipse-standard-luna-SR2-win32-x86_64.zip。
安装路径如：D:\Eclipse\EclipseLuna

## 1.4. 下载解压 hadoop2x-eclipse-plugin-master.zip

自行搜索 hadoop2x-eclipse-plugin，下载到本地，解压到：D:\Eclipse 路径下。

# 2、修改编译文件

	编译 hadoop-eclipse-plugins-2.8.5.jar时，主要修改以下两个文件：
	~\hadoop2x-eclipse-plugin-master\src\contrib\eclipse-plugin\build.xml
	~\hadoop2x-eclipse-plugin-master\ivy\libraries.properties

## 修改文件 build.xml

修改 ~\hadoop2x-eclipse-plugin-master\src\contrib\eclipse-plugin\build.xml 文件如下：

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->

<project default="jar" name="eclipse-plugin">

  <import file="../build-contrib.xml"/>

  <path id="eclipse-sdk-jars">
    <fileset dir="${eclipse.home}/plugins/">
      <include name="org.eclipse.ui*.jar"/>
      <include name="org.eclipse.jdt*.jar"/>
      <include name="org.eclipse.core*.jar"/>
      <include name="org.eclipse.equinox*.jar"/>
      <include name="org.eclipse.debug*.jar"/>
      <include name="org.eclipse.osgi*.jar"/>
      <include name="org.eclipse.swt*.jar"/>
      <include name="org.eclipse.jface*.jar"/>

      <include name="org.eclipse.team.cvs.ssh2*.jar"/>
      <include name="com.jcraft.jsch*.jar"/>
    </fileset> 
  </path>

  <path id="hadoop-sdk-jars">
    <fileset dir="${hadoop.home}/share/hadoop/mapreduce">
      <include name="hadoop*.jar"/>
    </fileset> 
    <fileset dir="${hadoop.home}/share/hadoop/hdfs">
      <include name="hadoop*.jar"/>
    </fileset> 
    <fileset dir="${hadoop.home}/share/hadoop/common">
      <include name="hadoop*.jar"/>
    </fileset> 
  </path>



  <!-- Override classpath to include Eclipse SDK jars -->
  <path id="classpath">
    <pathelement location="${build.classes}"/>
    <!--pathelement location="${hadoop.root}/build/classes"/-->
    <path refid="eclipse-sdk-jars"/>
    <path refid="hadoop-sdk-jars"/>
  </path>

  <!-- Skip building if eclipse.home is unset. -->
  <target name="check-contrib" unless="eclipse.home">
    <property name="skip.contrib" value="yes"/>
    <echo message="eclipse.home unset: skipping eclipse plugin"/>
  </target>

  <!-- target name="compile" depends="init, ivy-retrieve-common" unless="skip.contrib" -->
 <target name="compile" depends="init" unless="skip.contrib">
    <echo message="contrib: ${name}"/>
    <javac
     encoding="${build.encoding}"
     srcdir="${src.dir}"
     includes="**/*.java"
     destdir="${build.classes}"
     includeAntRuntime="false"
     debug="${javac.debug}"
     deprecation="${javac.deprecation}">
     <classpath refid="classpath"/>
    </javac>
  </target>

  <!-- Override jar target to specify manifest -->
  <target name="jar" depends="compile" unless="skip.contrib">
    <mkdir dir="${build.dir}/lib"/>
    <copy  todir="${build.dir}/lib/" verbose="true">
          <fileset dir="${hadoop.home}/share/hadoop/mapreduce">
           <include name="hadoop*.jar"/>
          </fileset>
    </copy>
    <copy  todir="${build.dir}/lib/" verbose="true">
          <fileset dir="${hadoop.home}/share/hadoop/common">
           <include name="hadoop*.jar"/>
          </fileset>
    </copy>
    <copy  todir="${build.dir}/lib/" verbose="true">
          <fileset dir="${hadoop.home}/share/hadoop/hdfs">
           <include name="hadoop*.jar"/>
          </fileset>
    </copy>
    <copy  todir="${build.dir}/lib/" verbose="true">
          <fileset dir="${hadoop.home}/share/hadoop/yarn">
           <include name="hadoop*.jar"/>
          </fileset>
    </copy>

    <copy  todir="${build.dir}/classes" verbose="true">
          <fileset dir="${root}/src/java">
           <include name="*.xml"/>
          </fileset>
    </copy>



    <copy file="${hadoop.home}/share/hadoop/common/lib/protobuf-java-${protobuf.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/log4j-${log4j.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/commons-cli-${commons-cli.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/commons-configuration-${commons-configuration.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/commons-lang-${commons-lang.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/commons-collections-${commons-collections.version}.jar"  todir="${build.dir}/lib" verbose="true"/>  
    <copy file="${hadoop.home}/share/hadoop/common/lib/jackson-core-asl-${jackson.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/jackson-mapper-asl-${jackson.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/httpclient-${httpclient.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/slf4j-log4j12-${slf4j-log4j12.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/slf4j-api-${slf4j-api.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/guava-${guava.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/hadoop-auth-${hadoop.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/netty-${netty.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/htrace-core4-${htrace.version}-incubating.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/woodstox-core-${woodstox.version}.jar"  todir="${build.dir}/lib" verbose="true"/>
    <copy file="${hadoop.home}/share/hadoop/common/lib/stax2-api-${stax2.version}.jar"  todir="${build.dir}/lib" verbose="true"/>

    <jar
      jarfile="${build.dir}/hadoop-${name}-${hadoop.version}.jar"
      manifest="${root}/META-INF/MANIFEST.MF">
      <manifest>
   <attribute name="Bundle-ClassPath" 
    value="classes/, 
 lib/hadoop-hdfs-client-${hadoop.version}.jar,
 lib/hadoop-mapreduce-client-core-${hadoop.version}.jar,
 lib/hadoop-mapreduce-client-common-${hadoop.version}.jar,
 lib/hadoop-mapreduce-client-jobclient-${hadoop.version}.jar,
 lib/hadoop-auth-${hadoop.version}.jar,
 lib/hadoop-common-${hadoop.version}.jar,
 lib/hadoop-hdfs-${hadoop.version}.jar,
 lib/protobuf-java-${protobuf.version}.jar,
 lib/log4j-${log4j.version}.jar,
 lib/commons-cli-${commons-cli.version}.jar,
 lib/commons-configuration-${commons-configuration.version}.jar,
 lib/commons-lang-${commons-lang.version}.jar,  
 lib/commons-collections-${commons-collections.version}.jar,  
 lib/jackson-core-asl-${jackson.version}.jar,
 lib/jackson-mapper-asl-${jackson.version}.jar,
 lib/httpclient-${httpclient.version}.jar,
 lib/slf4j-log4j12-${slf4j-log4j12.version}.jar,
 lib/slf4j-api-${slf4j-api.version}.jar,
 lib/guava-${guava.version}.jar,
 lib/netty-${netty.version}.jar,
 lib/servlet-api-${servlet-api.version}.jar,
 lib/htrace-core4-${htrace.version}-incubating.jar,
 lib/commons-io-${commons-io.version}.jar"/>
   </manifest>
      <fileset dir="${build.dir}" includes="classes/ lib/"/>
      <!--fileset dir="${build.dir}" includes="*.xml"/-->
      <fileset dir="${root}" includes="resources/ plugin.xml"/>
    </jar>
  </target>

</project>
```

## 修改文件 libraries.properties

修改 ~\hadoop2x-eclipse-plugin-master\ivy\libraries.properties 文件如下：

```bash
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#This properties file lists the versions of the various artifacts used by hadoop and components.
#It drives ivy and the generation of a maven POM

# This is the version of hadoop we are generating
hadoop.version=2.8.5
hadoop-gpl-compression.version=0.1.0

#These are the versions of our dependencies (in alphabetical order)
apacheant.version=1.7.0
ant-task.version=2.0.10

asm.version=3.2
aspectj.version=1.6.5
aspectj.version=1.6.11

checkstyle.version=4.2

commons-cli.version=1.2
commons-codec.version=1.4
commons-collections.version=3.2.2
commons-configuration.version=1.6
commons-daemon.version=1.0.13
commons-httpclient.version=3.0.1
commons-lang.version=2.6
commons-logging.version=1.1.3
commons-logging-api.version=1.1.3
commons-math.version=3.1.1
commons-el.version=1.0
commons-fileupload.version=1.2
commons-io.version=2.4
commons-net.version=3.1
core.version=3.1.1
coreplugin.version=1.3.2

hsqldb.version=1.8.0.10
htrace.version=4.0.1
httpclient.version=4.5.2

ivy.version=2.1.0

jasper.version=5.5.12
jackson.version=1.9.13
#not able to figureout the version of jsp & jsp-api version to get it resolved throught ivy
# but still declared here as we are going to have a local copy from the lib folder
jsp.version=2.1
jsp-api.version=5.5.12
jsp-api-2.1.version=6.1.14
jsp-2.1.version=6.1.14
jets3t.version=0.6.1
jetty.version=6.1.26
jetty-util.version=6.1.26
jersey-core.version=1.9
jersey-json.version=1.9
jersey-server.version=1.9
junit.version=4.11
jdeb.version=0.8
jdiff.version=1.0.9
json.version=1.0

kfs.version=0.1

log4j.version=1.2.17
lucene-core.version=2.3.1

mockito-all.version=1.8.5
jsch.version=0.1.54

oro.version=2.0.8

rats-lib.version=0.5.1

servlet.version=4.0.6
servlet-api.version=2.5
slf4j-api.version=1.7.10
slf4j-log4j12.version=1.7.10

wagon-http.version=1.0-beta-2
woodstox.version=5.0.3
stax2.version=3.1.4
xmlenc.version=0.52
xerces.version=1.4.4

protobuf.version=2.5.0
guava.version=11.0.2
netty.version=3.6.2.Final
```

# 3、进行编译

## 3.1. 执行命令

```
ant jar -Dversion=2.8.5 -Declipse.home=D:\Eclipse\EclipseLuna -Dhadoop.home=D:\hadoop-2.8.5
或
ant jar -Dhadoop.version=2.8.5 -Declipse.home=D:\Eclipse\EclipseLuna -Dhadoop.home=D:\hadoop-2.8.5
```

## 3.2. 编译成功

出现如下命令时表示编译成功

```bash
BUILD SUCCESSFUL
Total time: 2 seconds
```

## 3.3. 复制编译文件

将 `~\hadoop2x-eclipse-plugin-master\build\contrib\eclipse-plugin` 文件下的 **`hadoop-eclipse-plugins-2.8.5.jar`** 到 `~\EclipseLuna\plugins`。

到此，编译 **`hadoop-eclipse-plugins-2.8.5.jar`** 结束。
