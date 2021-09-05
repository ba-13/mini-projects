# Random_Stuff

All Random things I did finish.

## How not to frick up like I did.

> Commit regularly, that's the best thing you can do while using git.

The problem I faced, big time, is I didn't commit 3 applications, individually.  
Lost all 3. How? Cause I'm stupid. Actually I forgot to gitignore `node_modules`, and did `git add *`.  
Now seeing everything added up, the worst thing happened. Typing `git reset...`, autocompleted, and I hit enter.  
All 3 applications, now gone. Uncommitted blobs. I fucked up, big time.  
The 3 applications were an API, a pygame, and a todoList.
You can't recover uncommitted blobs with `reset --hard`.  
Hehe.  
Take the advice, do care of committing after you complete something. Please.  
And moreover, always take a backup.  
You must not be working directly in such a combined repo, so work somewhere else, and don't cut paste that application directory here. Only copy paste.  
AND never use `git reset head --hard` unless you know you have at least committed.
The file lostOnes includes all the files I have, that can be recovered by manually going through each of them.  
There are freaking 2000+ files, all due to I committed node_modules.

> So keep a .gitignore from the start.

That's all.
