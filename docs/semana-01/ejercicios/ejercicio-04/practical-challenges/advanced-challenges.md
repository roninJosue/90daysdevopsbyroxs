# Desafío 1: Rebase Interactivo
Nos permite poder renombrar, borrar, editar o unir commits en uno solo.
```bash
    $ git rebase -i HEAD~5
    hint: Waiting for your editor to close the file...
```
Esto nos abre el editor de texto con un listado de los últimos 5 commits

```bash
    pick f91bab4 Commit A
    pick 1330e71 Commit B
    pick 69e81c6 Commit C
    pick 97e4a33 Commit D
    pick c6abfee Commit E
```

Ahora nos toca decidir que acciones vamos a realizar sobre cada commit:
* **pick**: Mantiene el commit como está
* **reword**: Te permite cambiar el mensaje del commit
* **edit**: Te permite editar el contenido del commit
* **squash**: Fusiona este commit con el anterior
* **drop**: Elimina ese commit

```bash
    pick 2515dd4 Commit E
    reword f91bab4 Commit A, Modificado
    pick 1330e71 Commit B
    squash 69e81c6 Commit C
    drop c6abfee Commit D
```
Reordené el Commit E, cambié el mensaje de commit al commit A, eliminé Commit D 

```bash
    $ git log --oneline
    cb90a37 (HEAD -> main) Commit B, Commit C
    0ca9a30 Commit A Modificado
    f885dea Commit E
```
# Desafío 2: Cherry Pick
Nos permite poder pasar un commit específico a otra rama, por ejemplo hemos corregido un bug en la rama x, pero tenemos más cambios ahi, entonces si solo queremos pasar ese cambio, empleamos cherry pick de la siguiente manera:
```bash
    $ git log --oneline
    9297e50 (HEAD -> advanced-git-practice) Creado el modulo Users
    1f18574 (origin/advanced-git-practice) Tercer commit
    9091b08 Segundo commit
    005703e Commit inicial
```
Voy a copiar el commit 9297e50 de la rama advanced-git-practice a la rama main. Nos cambiamos a main y hacemos cherry pick
```bash
    $ git switch main
    Switched to branch 'main'
```
```bash
    $ git cherry-pick 9297e50
    [main 5062c42] Creado el modulo Users
     Date: Mon Jun 23 16:18:46 2025 -0600
     1 file changed, 1 insertion(+)
     create mode 100644 users.js
```
Se ha creado un nuevo commit en main, con los cambios del commit copiado.

# Desafío 3: Escenario de Conflicto de Merge
Es muy común, cuando trabajamos en equipo, que surjan conflictos al unir ramas, vamos a ver un escenario así.

Creamos un nuevo repositorio.
```bash
    $ git init merge-conflict-demo && cd merge-conflict-demo
    Initialized empty Git repository in C:/Users/Reynaldo/projects/merge-conflict-demo/.git/
```

Agregamos un archivo nuevo.
```bash
    $ echo "Línea 1" > conflicto.txt
```
```bash
    $ git add conflicto.txt
    warning: in the working copy of 'conflicto.txt', LF will be replaced by CRLF the next time Git touches it
```
Lo agregamos al historial.
```bash
    $ git commit -m "Commit inicial"
    [main (root-commit) 2f9fb9d] Commit inicial
     1 file changed, 1 insertion(+)
     create mode 100644 conflicto.txt
```
Creamos otra rama.
```bash
    $ git checkout -b feature-branch
    Switched to a new branch 'feature-branch'
```
Modificamos el archivo creado en main.
```bash
    $ echo "Cambio desde feature branch" > conflicto.txt
```
```bash
    $ git commit -am "Modificado conflicto.txt en feature-branch"
    warning: in the working copy of 'conflicto.txt', LF will be replaced by CRLF the next time Git touches it
    [feature-branch ac51c8a] Modificado conflicto.txt en feature-branch
     1 file changed, 1 insertion(+), 1 deletion(-)
```
Vamos nuevamente a main.
```bash
    $ git switch main
    Switched to branch 'main'
```
Y volvemos a modificar el mismo archivo.
```bash
    $ echo "Cambio desde main branch" > conflicto.txt
```
```bash
    $ git commit -am "Modificado conflicto.txt en main"
    warning: in the working copy of 'conflicto.txt', LF will be replaced by CRLF the next time Git touches it
    [main 0228fa2] Modificado conflicto.txt en main
     1 file changed, 1 insertion(+), 1 deletion(-)
```
Procedemos a hacer el merge, en este caso va a dar conflicto, ya que ambas ramas modificaron el archivo conflicto.txt.
```bash
    $ git merge feature-branch
    Auto-merging conflicto.txt
    CONFLICT (content): Merge conflict in conflicto.txt
    Automatic merge failed; fix conflicts and then commit the result.
```
Ahora debemos de corregir el conflicto de manera manual, desde nuestro editor de código abrimos el archivo y lo editamos.
```bash
    $ git status
    On branch main
    All conflicts fixed but you are still merging.
      (use "git commit" to conclude merge)
    
    Changes to be committed:
            modified:   conflicto.txt
```
Creamos el commit para terminar el merge.
```bash
    $ git commit -m "Resuelto conflicto de merge"
    [main aa5887a] Resuelto conflicto de merge
```
Método alternativo usando rebase. Eliminamos el merge commit.
```bash
    $ git reset --hard HEAD~1
    HEAD is now at 0228fa2 Modificado conflicto.txt en main
```

Nos cambiamos de rama.
```bash
    $ git checkout feature-branch
    Switched to branch 'feature-branch'
```
Hacemos el rebase.
```bash
    $ git rebase main
    Auto-merging conflicto.txt
    CONFLICT (content): Merge conflict in conflicto.txt
    error: could not apply ac51c8a... Modificado conflicto.txt en feature-branch
    hint: Resolve all conflicts manually, mark them as resolved with
    hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
    hint: You can instead skip this commit: run "git rebase --skip".
    hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
    hint: Disable this message with "git config set advice.mergeConflict false"
    Could not apply ac51c8a... Modificado conflicto.txt en feature-branch
```
Como tenemos un conflicto, debemos de corregirlo manualmente desde nuestro editor de código. Luego seguimos con el rebase.
```bash
    $ git status
    interactive rebase in progress; onto 0228fa2
    Last command done (1 command done):
       pick ac51c8a Modificado conflicto.txt en feature-branch
    No commands remaining.
    You are currently rebasing branch 'feature-branch' on '0228fa2'.
      (all conflicts fixed: run "git rebase --continue")
    
    Changes to be committed:
      (use "git restore --staged <file>..." to unstage)
            modified:   conflicto.txt
```
```bash
    $ git rebase --continue
    [detached HEAD eb521ec] Modificado conflicto.txt en feature-branch
     1 file changed, 1 insertion(+)
    Successfully rebased and updated refs/heads/feature-branch.
```
# Desafío 4: Deshacer Commits
## Reset
Creamos un nuevo repositorio para hacer el ejercicio.
```bash
    $ git init undo-demo && cd undo-demo
    Initialized empty Git repository in C:/Users/Reynaldo/projects/undo-demo/.git/
```
Creamos commits.
```bash
    $ echo "Primer commit" > archivo.txt
```
```bash
    $ git add archivo.txt
```
```bash
    $ git commit -m "Primer commit"
    [main (root-commit) 6abe8a8] Primer commit
     1 file changed, 1 insertion(+)
     create mode 100644 archivo.txt
```
```bash
    $ echo "Segundo commit" >> archivo.txt
```
```bash
    $ git commit -am "Segundo commit"
    warning: in the working copy of 'archivo.txt', LF will be replaced by CRLF the next time Git touches it
    [main a8190f0] Segundo commit
     1 file changed, 1 insertion(+)
```
```bash
$ echo "Tercer commit" >> archivo.txt
```
```bash
    $ git commit -am "Tercer commit"
    warning: in the working copy of 'archivo.txt', LF will be replaced by CRLF the next time Git touches it
    [main 47557c5] Tercer commit
     1 file changed, 1 insertion(+)
```
```bash
    $ git log --oneline -n 3
    47557c5 (HEAD -> main) Tercer commit
    a8190f0 Segundo commit
    6abe8a8 Primer commit
```

Ahora vamos a usar el commando reset, el cual tiene 3 opciones:
* **--hard**: Elimina todo.
* **--mixed**: Mantiene cambios en el staging.
* **--soft**: Mantiene cambios en el working directory.

### Soft reset
```bash
    $ git reset --soft HEAD~1
```
Ha eliminado el commit, pero los cambios los mantiene en el staging.
```bash
    $ git status
    On branch main
    Changes to be committed:
      (use "git restore --staged <file>..." to unstage)
            modified:   archivo.txt
```
```bash
    $ git log --oneline
    a8190f0 (HEAD -> main) Segundo commit
    6abe8a8 Primer commit
```
### Mixed reset
```bash
$ git reset --mixed HEAD~1
Unstaged changes after reset:
M       archivo.txt
```
Commit eliminado y también los cambios del staging, este es la option por defecto si no se le pasa ninguna.

### Hard reset
```bash
    $ git reset --hard HEAD~1
    HEAD is now at 6abe8a8 Primer commit
```
La opción más peligrosa

## Revert
Con el comando revert, podemos eliminar el commit, pero en esta ocasión se crea uno nuevo revirtiendo los cambios.
```bash
    $ git revert HEAD
```
Esto nos abrirá el editor de código para agregar el mensaje del commit revert.
```bash
    $ git log --oneline
    7e4f879 (HEAD -> main) Revert usado para deshacer cambios en el archivo.txt
    39520fc Eliminar commit usando revert
    6abe8a8 Primer commit
```
# Desafío 5: Amend de Commits
## Modificar el mensaje del último commit.
```bash
    $ git commit --amend -m "Mensaje de commit actualizado"
    [main 1f804ea] Mensaje de commit actualizado
     Date: Mon Jun 23 19:00:57 2025 -0600
     1 file changed, 1 deletion(-)
```
## Agregar archivo olvidado
```bash
    $ echo "Contenido nuevo" > olvidado.txt
```
```bash
    $ git add olvidado.txt
```
```bash
    $ git commit --amend --no-edit
    [main ce88b9d] Mensaje de commit actualizado
     Date: Mon Jun 23 19:00:57 2025 -0600
     2 files changed, 1 insertion(+), 1 deletion(-)
     create mode 100644 olvidado.txt
```

# Desafío 6: Git Hooks
Nos permiten ejecutar scripts cuando ocurre algún evento como: commit, push, merge, etc. Están en la carpeta .git/hooks/

Vamos a crear un git hook para el evento pre commit, que como su nombre lo indica se ejecuta antes de hacer un commit. 

```bash
    #!/bin/bash
    
    # Buscar console.log en archivos staged
    if git diff --cached --name-only | grep -E '\.js$|\.ts$' | xargs grep -n "console.log"; then
      echo "Commit bloqueado: se encontró 'console.log'"
      exit 1
    fi
    
    echo "Sin console.log, commit permitido"
    exit 0
```
Lo que hace este hook es tomar todos los archivos .js y .ts del staging y verifica ti tienen un console.log. Si es asi, se cancela el commit.
Supongamos que en el staging tenemos un archivo llamado hola.js, que en su contenido tiene un console.log, si tratamos de hacer commit, no nos va a permitir.

```bash
    $ cat hola.js
    console.log('Hola Mundo');
```
```bash
    $ git status
    On branch main
    Changes to be committed:
      (use "git restore --staged <file>..." to unstage)
            new file:   hola.js
```
```bash
    $ git commit -m "Se agrega hola.js"
    1:console.log('Hola Mundo');
    Commit bloqueado: se encontró 'console.log'
```
