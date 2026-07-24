# Procesador RISC-V RV32I segmentado

Implementacion en Verilog/SystemVerilog de un procesador educativo de 32 bits
inspirado en el subconjunto base **RISC-V RV32I**. El nucleo usa un *pipeline*
de cinco etapas, incorpora resolucion de dependencias de datos y puede
integrarse con una Nexys4 mediante un envoltorio que muestra el banco de
registros en los displays de siete segmentos.

> **Estado del proyecto:** el diseno es una implementacion en desarrollo, no
> una implementacion completa ni conforme de forma integral a la especificacion
> RV32I. Consulte [Alcance y limitaciones](#alcance-y-limitaciones) antes de
> usarlo como referencia de compatibilidad.

## Caracteristicas

- Camino de datos de 32 bits y 32 registros de proposito general.
- Pipeline clasico de cinco etapas: IF, ID, EX, MEM y WB.
- PC secuencial con incremento de 4 bytes y redireccionamiento de ramas.
- ROM de instrucciones combinacional integrada.
- ALU para suma, resta, AND y OR.
- *Forwarding* hacia EX desde EX/MEM y MEM/WB.
- Deteccion de la dependencia carga-uso y burbuja en ID/EX.
- Vaciado de IF/ID e ID/EX al tomar una rama.
- RAM de datos parametrizable, con 256 palabras de 32 bits por defecto.
- Integracion de botones antirrebote, LEDs y displays de la Nexys4.
- Bancos de prueba autocontenidos para fetch, ramas, vaciado y hazards.

## Arquitectura

El modulo superior es `RISC_V`, definido en `rtl/riscv.sv`. Ademas del nucleo,
incluye la logica de visualizacion especifica de placa. Las etapas se conectan
mediante registros de pipeline:

| Etapa | Bloques principales | Responsabilidad |
| --- | --- | --- |
| IF | `FETCH`, `InstructionMem`, `IF_ID_PIPELINE` | Mantiene el PC, obtiene la instruccion y la registra para decodificacion. |
| ID | `DECO`, `CONTROL_UNIT`, `Banco_registros`, `ID_EXE_PIPELINE` | Decodifica opcode, lee registros, extiende el inmediato y genera control. |
| EX | `EXE`, `ALU_FINAL`, `Alu_ctrl`, `SHIFTER` | Ejecuta la ALU, realiza comparaciones de rama, calcula el destino y aplica forwarding. |
| MEM | `EXE_MEN_PIPELINE`, `MEM`, `MemDatos` | Accede a la memoria de datos y propaga el resultado de ALU. |
| WB | `MEM_WB_PIPELINE`, `WR` | Selecciona entre resultado de ALU y lectura de memoria para escribir `rd`. |

Las instrucciones se obtienen de `rtl/instructionmem.sv`. La ROM se expresa
como un `case` sobre una direccion en bytes: actualmente contiene un programa
de prueba que comienza en la direccion 148. Para cambiar el programa, edite
las parejas direccion/palabra de ese archivo y conserve palabras RISC-V de
32 bits codificadas en hexadecimal.

### Riesgos de datos y control

`HAZARD_UNIT` identifica una dependencia entre el destino de una carga en
ID/EX y los registros fuente de la instruccion en ID. Ante esa condicion
detiene PC e IF/ID e inserta una burbuja en ID/EX.

En EX, `EXE` prioriza el resultado de EX/MEM sobre MEM/WB. Un resultado de
carga no se reenvia desde EX/MEM, sino desde MEM/WB una vez disponible. Las
ramas se resuelven en EX; cuando se toma una, `FETCH` carga el destino y los
registros IF/ID e ID/EX se limpian.

## Alcance y limitaciones

El soporte debe interpretarse a partir del RTL, no solo del opcode. El estado
actual es el siguiente:

| Grupo | Implementado o probado | Observaciones |
| --- | --- | --- |
| Operaciones ALU | `ADD`, `SUB`, `AND`, `OR`, `ADDI`, `ANDI`, `ORI` | La ALU no implementa desplazamientos, comparaciones `SLT/SLTU`, ni las extensiones M, A, F, D o C. |
| Control de flujo | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` | Las comparaciones se realizan en EX y el desplazamiento de branch se calcula como `PC + (inmediato << 1)`. No hay `JAL`, `JALR`, traps ni interrupciones. |
| Carga y almacenamiento | Camino de datos para `LW` y `SW` | Solo se transportan palabras de 32 bits; no existen `LB`, `LBU`, `LH`, `LHU` ni `SB`/`SH`. |
| Registros | 32 registros visibles; `x0` se fuerza a cero al escribir | El banco se inicializa en reset y se actualiza en flanco negativo. |
| Memoria de datos | 256 entradas de 32 bits, parametrizables | La direccion se usa directamente como indice de arreglo, sin traducir direccion por bytes a indice de palabra, sin comprobacion de rango y sin control de alineacion. El elemento 255 no se reinicializa en el bucle actual de reset. |
| ISA y excepciones | Subconjunto educativo | No hay CSR, modos de privilegio, excepciones, E/S mapeada, temporizadores ni contrato de compatibilidad con binarios RV32I generales. |

En particular, la unidad de control activa `MemRead` para instrucciones
aritmeticas inmediatas aunque el write-back selecciona el resultado de ALU.
No suele modificar su resultado, pero es trabajo pendiente de la semantica de
memoria. El plan de correcciones y ampliaciones se mantiene en
[`docs/work_plan.md`](docs/work_plan.md).

## Estructura del repositorio

```text
.
|-- rtl/                 # Modulos sintetizables de Verilog y SystemVerilog
|-- verif/               # Bancos de prueba y registros de simulacion
|   |-- tb_fetch.sv
|   |-- tb_branch.sv
|   |-- tb_pipeline_flush.sv
|   `-- tb_hazards.sv
|-- docs/
|   `-- work_plan.md     # Estado y tareas tecnicas pendientes
|-- nexys4.xdc           # Restricciones de pines para Nexys4 rev. B
`-- readme.md
```

Hay archivos historicos o prototipos en `rtl/` (`new.v`, `nuevo.v`,
`memoria.sv` y `shifter.sv`). No deben incluirse de forma indiscriminada en
una compilacion: el desplazador usado por `EXE` es `rtl/shifter.v`.

## Requisitos

- [Icarus Verilog](https://steveicarus.github.io/iverilog/) 12 o posterior
- Verilator con soporte de SystemVerilog para ejecutar los scripts de
  `scripts/`
  para ejecutar la verificacion RTL desde linea de comandos.
- Opcionalmente, Xilinx Vivado para sintesis, implementacion y programacion
  de la Nexys4.

Los comandos siguientes se ejecutan desde la raiz del repositorio y crean los
artefactos temporales dentro de `build/`.

## Simulacion

### Verilator

En PowerShell, ejecute toda la suite con Verilator:

```powershell
.\scripts\run_verilator.ps1
```

Para ejecutar un banco individual, sustituya `tb_fetch` por cualquiera de
`tb_branch`, `tb_pipeline_flush` o `tb_hazards`:

```powershell
.\scripts\run_verilator.ps1 -Test tb_fetch
```

Los binarios y archivos intermedios se generan en `build/verilator/`. El
script fuerza `--no-fourstate`: el PR experimental #7193 de Verilator todavia
no admite el uso de `case` ni asignaciones parciales presentes en este RTL, por
lo que el procesador no se puede ejecutar actualmente con `--fourstate`.

### Ejecutar todas las pruebas disponibles

En PowerShell:

```powershell
New-Item -ItemType Directory -Force build | Out-Null

iverilog -g2012 -s tb_fetch -o build/tb_fetch `
  rtl/fetch.sv rtl/instructionmem.sv verif/tb_fetch.sv
vvp build/tb_fetch

iverilog -g2012 -s tb_branch -o build/tb_branch `
  rtl/deco.sv rtl/control_unit.sv rtl/banco_registros.sv rtl/ext_signo.sv `
  rtl/exe.sv rtl/alu_final.sv rtl/alu.sv rtl/alu_ctrl.sv rtl/shifter.v `
  verif/tb_branch.sv
vvp build/tb_branch

iverilog -g2012 -s tb_pipeline_flush -o build/tb_pipeline_flush `
  rtl/if_id_pipeline.sv rtl/id_exe_pipeline.sv verif/tb_pipeline_flush.sv
vvp build/tb_pipeline_flush

iverilog -g2012 -s tb_hazards -o build/tb_hazards `
  rtl/exe.sv rtl/hazard_unit.sv rtl/alu_final.sv rtl/alu.sv rtl/alu_ctrl.sv `
  rtl/shifter.v verif/tb_hazards.sv
vvp build/tb_hazards
```

Cada banco usa `$fatal` ante un resultado inesperado y muestra
`tb_<nombre> passed` al terminar correctamente:

| Banco | Cobertura |
| --- | --- |
| `tb_fetch.sv` | Reset del PC, avance secuencial, redireccionamiento y lectura de ROM. |
| `tb_branch.sv` | Inmediato B, `BEQ`, `BLT`, `BLTU` y desplazamiento negativo. |
| `tb_pipeline_flush.sv` | Limpieza de IF/ID e insercion de burbuja en ID/EX. |
| `tb_hazards.sv` | Prioridad de forwarding y stall de carga-uso. |

Los registros de ejecuciones previas se almacenan en `verif/logs/`. No
sustituyen a ejecutar los bancos contra el RTL actual.

## Sintesis e integracion con Nexys4

1. Cree un proyecto RTL en Vivado para la FPGA instalada en su Nexys4.
2. Agregue los fuentes necesarios de `rtl/`, seleccionando `rtl/riscv.sv`
   como modulo superior y excluyendo los prototipos indicados anteriormente.
3. Agregue `nexys4.xdc`. Sus nombres de puerto corresponden al envoltorio
   `RISC_V`: `clk`, `rst`, `tick_r_in`, `tick_l_in`, `out_disp`, `an0` a
   `an7` y `leds`.
4. Revise las restricciones antes de implementar: el archivo contiene una
   plantilla amplia de Nexys4 y solo algunas lineas estan activas. Confirme
   que la revision de la placa y los pines habilitados coincidan con el
   hardware.
5. Sintetice, implemente, genere el bitstream y programe la placa desde
   Vivado.

Los botones `tick_r_in` y `tick_l_in` se antirrebotean y seleccionan el
registro que se presenta. Los LEDs muestran su indice y los displays muestran
el valor de 32 bits del registro seleccionado. La frecuencia de reloj no se
divide en el modulo superior; la restriccion activa de `nexys4.xdc` documenta
un reloj de 100 MHz mediante un comentario que debe revisarse y habilitarse
segun el proyecto.

## Convenciones de desarrollo

- Mantenga los nuevos bancos de prueba en `verif/` y nombre el modulo superior
  como `tb_<funcion>`.
- Incluya comprobaciones automaticas y finalice la simulacion con `$fatal`
  cuando falle una expectativa.
- Actualice esta documentacion y `docs/work_plan.md` al ampliar el
  subconjunto de instrucciones o modificar las interfaces.
- Antes de añadir un archivo RTL al flujo, verifique que no duplique un modulo
  existente.

## Referencias

- RISC-V International, *The RISC-V Instruction Set Manual, Volume I:
  Unprivileged Architecture*. La especificacion oficial define el
  comportamiento normativo de RV32I.
- [`docs/work_plan.md`](docs/work_plan.md), plan interno para completar la
  funcionalidad y cobertura de verificacion de este repositorio.
