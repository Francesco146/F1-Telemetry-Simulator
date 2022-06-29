# Relazione dell’Elaborato
## Architettura degli Elaboratori 2021 / 2022



# Indice
1. [Specifiche](#Specifiche)
2. [Variabili](#Variabili)
3. [Funzioni](#Funzioni)
   - [are_strings_equal](#are_strings_equal)
   - [get_pilot](#get_pilot)
   - [int2str](#int2str)
   - [is_my_pilot](#is_my_pilot)
   - [next_line](#next_line)
   - [output_max_avg](#output_max_avg)
   - [process_line](#process_line)
   - [str2int](#str2int)
   - [telemetry](#telemetry)
4. [Diagramma di flusso](#Diagramma-di-flusso)
5. [Scelte progettuali](#Scelte-progettuali)


## Specifiche
Si descriva un programma che simuli il sistema di telemetria del videogame F1.
Il sistema fornisce in input i dati grezzi di giri motore (rpm), temperatura motore e
velocità di tutti i piloti presenti in gara per ogni istante di tempo.
Ogni riga del file di input è così composta:
       `<tempo>,<id_pilota>,<velocità>,<rpm>,<temperatura>`
Il campo `id_pilota` rappresenta un valore numerico che identifica univocamente un pilota.
L’associazione tra id e nome del pilota è il seguente:

| ID|  Nome |
|:--:|:------------:|
| 0 | Pierre Gasly |
| 1 | Charles Leclerc |
| 2 | Max Verstappen |
| 3 | Lando Norris |
| 4 | Sebastian Vettel |
| 5 | Daniel Ricciardo |
| 6 | Lance Stroll |
| 7 | Carlos Sainz |
| 8 | Antonio Giovinazzi |
| 9 | Kevin Magnussen |
| 10 |  Alexander Albon |
| 11 |  Nicholas Latifi |
| 12 |  Lewis Hamilton |
| 13 |  Romain Grosjean |
| 14 |  George Russell |
| 15 |  Sergio Perez |
| 16 |  Daniil Kvyat |
| 17 |  Kimi Raikkonen |
| 18 |  Esteban Ocon |
| 19 |  Valtteri Bottas |

Nella prima riga del file di input è presente il nome di un pilota che si vuole monitorare.

Si scriva un programma in assembly che restituisca i dati relativi al solo pilota indicato nella prima riga del file, in base a delle soglie indicate.
Vengono definite tre soglie per tutti i dati monitorati: `LOW`, `MEDIUM`, `HIGH`.
Il file di output dovrà riportare queste soglie per tutti gli istanti di tempo in cui il pilota è monitorato.
Le righe del file di output saranno strutturate nel seguente modo e ordine:
`<tempo>,<livello rpm>,<livello temperatura>,<livello velocità>`
Inoltre, viene richiesto di aggiungere alla fine del file di output una riga aggiuntiva che contenga, nel seguente ordine: il numero di giri massimi rilevati, la temperatura massima rilevata, la velocità di picco e infine la velocità media.
La struttura dell’ultima riga sarà quindi la seguente:
`<rpm max>,<temp max>,<velocità max>,<velocità media>`
Infine, deve essere aggiunto un a capo dopo l’ultima riga.

Le istanze che verranno usate non contengono errori nei campi.
La velocità media viene calcolata come quoziente intero della divisione.
L’ordine dei campi del file di output DEVE seguire esattamente le specifiche.
Se il nome del pilota inserito non è valido il programma deve restituire la stringa Invalid seguita da un a capo (vedasi istanza 5 di esempio).

# Variabili
Ogni variabile di tipo stringa è terminata da `\0` per segnare la fine della stringa.

Nel file `src/telemetry.s`_
- `counter_speed`: `(long)` `(globale)` contatore delle occorrenze per la velocità, utilizzata per calcolare la velocità media
- `sum_speed`: `(long)` `(globale)` somma di tutte le velocità analizzate, utilizzata per calcolare la velocità media
- `max_temp`: `(long)` `(globale)` valore della temperatura massima analizzata
- `max_rpm`: `(long)` `(globale)` valore massimo dei giri del motore analizzati
- `max_speed`: `(long)` `(globale)` valore della velocità massima analizzata
- `pilot_id`: `(string)` id del pilota che si deve monitorare
- `invalid_pilot_str`: `(string)` stringa `Invalid\n` da stampare in caso di pilota non valido

Nel file `src/process_line.s`:
- `speed_value`: `(long)` valore della velocità nella riga analizzata
- `rpm_value`: `(long)` valore dei giri del motore nella riga analizzata
- `temp_value`: `(long)` valore della temperatura nella riga analizzata
- `high_str`: `(string)` stringa `“HIGH”` in caso il valore ricada nel livello alto
- `medium_str`: `(string)` stringa `“MEDIUM”` in caso il valore ricada nell'intervallo medio 
- `low_str`: `(string)` stringa `“LOW”` in caso il valore ricada nel livello basso

Nel file `int2string.s`:
- `numtmp`: `(string)` stringa temporanea che contiene il numerale

Nel file `get_pilot.s`:
- `pilot_n_str`: `(string)` contiene il nome del pilota con n l’id associato ad esso
- `pilots_array`: `(long)` indirizzo del primo elemento dell’array di stringhe
- `pilots_array_end`: `(long)` indirizzo dell’ultimo elemento dell’array di stringhe

# Funzioni
## str2int
Converte in intero la stringa contenuta nel registro `%ESI`, terminata dal carattere contenuto nel registro `%CL`.
Il valore di ritorno viene memorizzato nel registro `%EAX` ed al termine della funzione il registro `%ESI` punta al carattere dopo l’ultima cifra.
## int2str
Converte un valore intero in stringa.
Riceve tramite il registro `%EBX` l’intero da convertire e tramite `%EDI` l’indirizzo della stringa in cui scrivere il risultato.
## next_line
Incrementa il registro `%ESI` fintanto che l’indirizzo contenuto in esso non punta alla riga successiva presente nella stringa di input, ovvero al carattere successivo a `\n`.
## are_strings_equal
Controlla se due stringhe contenute nei registri `%EAX` ed `%ESI` sono uguali. La prima stringa è delimitata dal terminatore `\0` mentre la seconda dal carattere contenuto nel registro `%DL`. L’esito del confronto viene memorizzato nel registro `%ECX`.
## get_pilot
Ricava l’id del pilota associato al nome presente nella riga corrente della stringa in `%ESI`.
Compara la riga con ogni stringa presente nell’array `pilots_array` memorizzato nel registro `%EAX`.
Se il pilota da monitorare è valido viene memorizzato in `%EBX` l’id ad esso associato altrimenti viene segnalato l’errore memorizzando il valore `-1` in `%EBX`.
## is_my_pilot
Controlla se la riga corrente contenuta nel registro `%ESI` riguarda il pilota contenuto nel registro `%EAX`. L’esito del controllo viene memorizzato nel registro `%ECX`.
## output_levels
Confronta il valore contenuto nel registro `%EAX` con le soglie che delimitano il livello `LOW` e `MEDIUM` contenute rispettivamente nei registri `%EBX` ed `%ECX`. Scrive il livello associato all’intervallo nella stringa il cui indirizzo è memorizzato nel registro `%EDI`.
## process_line
Copia il campo `<tempo>` dalla stringa di input indirizzata dal `%ESI` alla stringa di output contenuta nel registro `%EDI`.
Inoltre converte i valori di velocità, temperatura e giri motore in intero e scrive nella stringa di output i livelli corrispondenti. Infine aggiorna i valori massimi e il valore della velocità media modificando le rispettive variabili globali.
## output_max_avg
Scrive nella stringa il cui indirizzo è contenuto nel registro `%EDI` i valori di giri motore, temperatura e velocità massimi. Inoltre calcola e scrive nella stringa di output la velocità media come quoziente intero della divisione.
## telemetry
Funzione che richiama le precedenti funzioni per implementare la specifica richiesta.
Ricava l’id del pilota da monitorare tramite [`get_pilot`](#get_pilot) e processa ogni riga della stringa di input tramite [`is_my_pilot`](#is_my_pilot) e [`process_line`](#process_line). Infine scrive in output i massimi e la velocità media tramite [`output_max_avg`](#output_max_avg). 
Si occupa inoltre di gestire l’eventualità di non aver trovato il pilota da analizzare.

# Diagramma di flusso
<img align="left" src="https://github.com/TomZanna/elaborato-asm/blob/main/images/image2.png?raw=true" width="400" height="700">
<img src="https://github.com/TomZanna/elaborato-asm/blob/main/images/image4.png?raw=true" width="300" height="800">
<img align="left" src="https://github.com/TomZanna/elaborato-asm/blob/main/images/image3.png?raw=true" width="300" height="300">
<img src="https://github.com/TomZanna/elaborato-asm/blob/main/images/image1.png?raw=true" width="400" height="700">

# Scelte progettuali
- Si è scelto di suddividere il programma in molteplici file per poter beneficiare della compilazione incrementale e velocizzare le compilazioni successive.
Inoltre le variabili e le etichette hanno una visibilità limitata al file dichiarante, purché non siano di visibilità globale. Il progetto appare quindi più ordinato e la navigazione all’interno del codice è immediata.
- Nel Makefile la variabile `_OBJ` contiene la lista dei file oggetto necessari al linking per produrre il binario telemetry.
- Il Makefile lo abbiamo ottimizzato rendendolo più astratto possibile inserendo alcune regole che fanno uso di pattern per i nomi dei file. 
- Per poter verificare il corretto funzionamento del nostro eseguibile, abbiamo scritto un piccolo script Bash per poter confrontare i valori resituiti con quelli consegnati dal professore. Lo script `test.sh` è riportato di seguito:

```bash  
# test.sh
#!/bin/bash 
for i in {1..6}; do
   if [ ! -f test/in_$i.txt ]; then
       echo "Skipping in_$i.txt"
   else
       printf "Processing in_$i.txt...";
       bin/telemetry test/in_$i.txt test/out_$i.asm.txt;
       diff test/out_$i.txt test/out_$i.asm.txt >/dev/null;
       if [ $? -eq 0 ]; then
           echo " ✔ Test passed!"
       else 
           echo " ✘ Test failed!"
       fi
   fi
done
```

