allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
    project.layout.buildDirectory.value(newBuildDir.dir(project.name))
    if (rootProject.subprojects.any { it.name == "app" }) {
        project.evaluationDependsOn(":app")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
    