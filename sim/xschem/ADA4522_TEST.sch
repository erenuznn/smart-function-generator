v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 -60 60 -60 {lab=#net1}
N 110 -0 110 30 {lab=#net2}
N 110 -150 190 -150 {lab=#net3}
N 110 -150 110 -80 {lab=#net3}
N -100 0 -100 90 {lab=0}
N 110 90 190 90 {lab=0}
N 190 -90 190 90 {lab=0}
N 110 90 110 110 {lab=0}
N -100 90 110 90 {lab=0}
N 60 -20 60 20 {lab=#net4}
N 60 20 160 20 {lab=#net4}
N 160 -40 160 20 {lab=#net4}
C {/foss/designs/sim/xschem/symbols/ada4522.sym} 110 -40 0 0 {}
C {vsource.sym} -100 -30 0 0 {name=V1 value=6 savecurrent=false}
C {vsource.sym} 110 60 0 0 {name=V3 value=-12 savecurrent=false}
C {vsource.sym} 190 -120 0 0 {name=V4 value=12 savecurrent=false}
C {gnd.sym} 110 110 0 0 {name=l1 lab=0}
C {code.sym} 240 -30 0 0 {name=s1 only_toplevel=false value=.op}
