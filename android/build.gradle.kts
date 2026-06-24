allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    fun configureNamespace(proj: Project) {
        if (proj.extensions.findByName("android") != null) {
            proj.extensions.configure<com.android.build.gradle.BaseExtension> {
                if (namespace.isNullOrEmpty()) {
                    val manifestFile = proj.file("src/main/AndroidManifest.xml")
                    if (manifestFile.exists()) {
                        val manifestContent = manifestFile.readText()
                        val packageMatch = Regex("package=\"([^\"]+)\"").find(manifestContent)
                        if (packageMatch != null) {
                            namespace = packageMatch.groupValues[1]
                        } else {
                            namespace = "com.example.${proj.name.replace("-", ".")}"
                        }
                    } else {
                        namespace = "com.example.${proj.name.replace("-", ".")}"
                    }
                }
            }
        }
    }

    if (state.executed) {
        configureNamespace(this)
    } else {
        afterEvaluate {
            configureNamespace(this)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
