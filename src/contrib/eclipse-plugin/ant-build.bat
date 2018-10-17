@cd /d D:\HadoopEclipse\hadoop2x-eclipse-plugin-master\src\contrib\eclipse-plugin
del /q /s D:\HadoopEclipse\hadoop2x-eclipse-plugin-master\build\contrib
ant jar -Dversion=2.8.5 -Declipse.home=D:\HadoopEclipse\EclipseLuna -Dhadoop.home=D:\HadoopEclipse\hadoop-2.8.5