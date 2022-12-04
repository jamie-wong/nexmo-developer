---
title: Create an Android project
description: In this step you create an Android project and add the Android Client SDK library.
---

# Create an Android project
## New Android Project

Create new `app-to-phone` folder inside `app-to-phone-java` folder:

```bash
mkdir app-to-phone
```

Open Android Studio and, from the menu, select `File` > `New` > `New Project...`. Select an `Empty Activity` template type and click `Next`.

![Create project](/screenshots/tutorials/client-sdk/android-shared/create-project-empty-activity.png)

Enter `app-to-phone` as project name, point location to previously created `app-to-phone-java/app-to-phone` folder,  select as `Java` language and press `Finish` button.

You now have a brand new Android Project.

## Add Client SDK dependency

You need to add a custom Maven URL repository to your Gradle configuration. Add the following `maven` block inside the `repositories` block within the project-level `settings.gradle` file:

![Setting gradle file in file explorer](/screenshots/tutorials/client-sdk/android-shared/settings-gradle-file.png)

```groovy
repositories {
    google()
    mavenCentral()
    maven {
        url "https://artifactory.ess-dev.com/artifactory/gradle-dev-local"
    }
}
```

If you are using an older version of Android Studio and there is no `dependencyResolutionManagement` in your `settings.gradle` file then add the maven block to the `repositories` block within the project-level `build.gradle` file:

![Build gradle file in the file explorer](/screenshots/tutorials/client-sdk/android-shared/project-level-build-gradle-file.png)

> **NOTE** You can use the `Navigate file` action to open any file in the project. Run the keyboard shortcut (Mac: `Shift + Cmd + O` ; Win: `Shift + Ctrl + O`) and type the filename.

Now add the Client SDK to the project. Add the following dependency in the module-level `build.gradle` file.:

![Build gradle](/screenshots/tutorials/client-sdk/android-shared/module-level-build-gradle-file.png)

```groovy
dependencies {
    // ...

    implementation 'com.nexmo.android:client-sdk:4.0.0'
}
```

Enable `jetifier` in the `gradle.properties` file by adding the below line:

```groovy
android.enableJetifier=true
```

Finally, you will need to increase the memory allocation for the JVM by editing the `org.gradle.jvmargs` property in your `gradle.properties` file. We recommend this be set to at least 4GB:

```groovy
org.gradle.jvmargs=-Xmx4096m -Dfile.encoding=UTF-8
```
