## Release Process ##

### Step 1: Creating a release branch ###

The branch structure in Aztec iOS is based on the [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) methodology.

These are the main branches involved in the release process:
```
master: Kept up to date with the latest release.
develop: Bleeding edge branch with all of the latest changes.
release/x.y.z: Version branch, which we will use during the release process.
```
The first step in the process is creating the version branch.

The version branch is what allows work to continue in develop while also having a frozen snapshot of what we’re releasing.

Using the command line, the process is pretty straightforward:

```
git checkout develop
git pull
git checkout -b release/x.y.z
git push origin -u release/x.y.z
```

Make sure to update the field `s.version` in both of these files to the `x.y.z` number
```
WordPress-Aztec-iOS.podspec
WordPress-Editor-iOS.podespec
```

Open a PR on github where you target the `master` branch with the `release/x.y.z` branch and call it `Release x.y.z`


### Step 2: Testing the Integration ###

Before going any further, tt's normally good practice to test the Aztec integration into [WordPress-iOS project](https://github.com/wordpress-mobile/WordPress-iOS), to make sure we won’t have to do the release process twice.

Make sure WordPress-iOS’s podfile specifies the SAME (and latest) commit number for both of these:
```
pod 'WordPress-Aztec-iOS', :git => 'https://github.com/wordpress-mobile/AztecEditor-iOS.git', :commit => 'e0fc55abb4809b3b23b6d8b56791798af864025d'
pod 'WordPress-Editor-iOS', :git => 'https://github.com/wordpress-mobile/AztecEditor-iOS.git', :commit => 'e0fc55abb4809b3b23b6d8b56791798af864025d'
```
The things we want to look out for are:

- That the pod can be properly installed in WPiOS.
- That WPiOS builds properly.
- That you can open a post through the App, using both the classic editor and Gutenberg.

### Step 3: Merge the branch ###

If the release PR is approved and all is working correctly in WP-iOS merge the release branch to master.

### Step 4: Push the POD. ###

*Automated Process*

Create a new release on Github targetting the master branch and name it `Release x.y.z`

Set a tag with the value `x.y.z` .  

On the description field and the content of the changelog for this version

Press the `Publish release` button

At this moment the CI automation should notice your tag and after some minutes you should get the new pod publish on CocoaPods master trunk.

If this for some reason fails chech the manual process bellow

*Manual Process*

Pushing the PODs is a bit different than in other repos due to the fact that this repo has two podspecs.

The recommended steps are:

Lint the core library
```
bundle exec pod lib lint WordPress-Aztec-iOS.podspec
```

If all is good proceed to
```
bundle exec pod trunk push WordPress-Aztec-iOS.podspec
```

Then lint the Editor library
```
bundle exec pod lib lint WordPress-Editor-iOS.podspec
```

If all is good, push it
```
bundle exec pod trunk push WordPress-Editor-iOS.podspec
```

### Step 5: Closing the milestone ###

For simplicity Aztec uses a single milestone named “Next Stable”. The purpose of this milestone is to be used to assign to it all of the regular issues that are closed and merged into develop during the regular development process.

At this point in the release process you should rename the milestone to the version you've just released.

Once renamed, you can create a new “Next Stable” milestone and assign all pending open issues to it.

At this point you’re ready to close the version milestone in GitHub.

### Step 6: Merge Master to develop ###

Following the git Flow methodology you now need to merge the master branch back to develop.

Create a new PR in GitHub that targets `develop` with the master branch.

After review, if all is ok, merge that PR and your work is done.
