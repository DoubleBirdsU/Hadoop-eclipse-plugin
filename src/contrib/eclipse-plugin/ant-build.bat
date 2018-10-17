@cd /d D:\HadoopEclipse\Hadoop-eclipse-plugin\src\contrib\eclipse-plugin
del /q /s D:\HadoopEclipse\Hadoop-eclipse-plugin\build\contrib
ant jar -Dversion=2.8.5 -Declipse.home=D:\HadoopEclipse\eclipse -Dhadoop.home=D:\HadoopEclipse\hadoop-2.8.5