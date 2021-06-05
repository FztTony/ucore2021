
/home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/user_shell:     file format elf64-littleriscv


Disassembly of section .startup:

0000000000001000 <_start>:
.text
.globl _start
_start:
    mv a0, sp
    1000:	850a                	mv	a0,sp
    tail __start_main
    1002:	04c0006f          	j	104e <__start_main>

Disassembly of section .text:

0000000000001006 <push>:

char line[100];
int top = 0;

void push(char c) {
    line[top++] = c;
    1006:	00001717          	auipc	a4,0x1
    100a:	de270713          	addi	a4,a4,-542 # 1de8 <top>
    100e:	4314                	lw	a3,0(a4)
    1010:	00001797          	auipc	a5,0x1
    1014:	d7078793          	addi	a5,a5,-656 # 1d80 <line>
    1018:	0016861b          	addiw	a2,a3,1
    101c:	97b6                	add	a5,a5,a3
    101e:	c310                	sw	a2,0(a4)
    1020:	00a78023          	sb	a0,0(a5)
}
    1024:	8082                	ret

0000000000001026 <pop>:

void pop() {
    --top;
    1026:	00001717          	auipc	a4,0x1
    102a:	dc270713          	addi	a4,a4,-574 # 1de8 <top>
    102e:	431c                	lw	a5,0(a4)
    1030:	37fd                	addiw	a5,a5,-1
    1032:	c31c                	sw	a5,0(a4)
}
    1034:	8082                	ret

0000000000001036 <is_empty>:

int is_empty() {
    return top == 0;
    1036:	00001517          	auipc	a0,0x1
    103a:	db252503          	lw	a0,-590(a0) # 1de8 <top>
}
    103e:	00153513          	seqz	a0,a0
    1042:	8082                	ret

0000000000001044 <clear>:

void clear() {
    top = 0;
    1044:	00001797          	auipc	a5,0x1
    1048:	da07a223          	sw	zero,-604(a5) # 1de8 <top>
}
    104c:	8082                	ret

000000000000104e <__start_main>:
#include <unistd.h>

extern int main();

int __start_main(long* p)
{
    104e:	1141                	addi	sp,sp,-16
    1050:	e406                	sd	ra,8(sp)
    exit(main());
    1052:	30d000ef          	jal	ra,1b5e <main>
    1056:	2a3000ef          	jal	ra,1af8 <exit>
    return 0;
}
    105a:	60a2                	ld	ra,8(sp)
    105c:	4501                	li	a0,0
    105e:	0141                	addi	sp,sp,16
    1060:	8082                	ret

0000000000001062 <getchar>:
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int getchar() {
    1062:	1101                	addi	sp,sp,-32
    char byte = 0;
    read(stdin, &byte, 1);
    1064:	00f10593          	addi	a1,sp,15
    1068:	4605                	li	a2,1
    106a:	4501                	li	a0,0
int getchar() {
    106c:	ec06                	sd	ra,24(sp)
    char byte = 0;
    106e:	000107a3          	sb	zero,15(sp)
    read(stdin, &byte, 1);
    1072:	24f000ef          	jal	ra,1ac0 <read>
    return byte;
}
    1076:	60e2                	ld	ra,24(sp)
    1078:	00f14503          	lbu	a0,15(sp)
    107c:	6105                	addi	sp,sp,32
    107e:	8082                	ret

0000000000001080 <putchar>:

int putchar(int c)
{
    1080:	1141                	addi	sp,sp,-16
    1082:	e406                	sd	ra,8(sp)
    1084:	87aa                	mv	a5,a0
    static char put[2] = {0, 0};
    put[0] = c;
    1086:	00001597          	auipc	a1,0x1
    108a:	d6a58593          	addi	a1,a1,-662 # 1df0 <put.1058>
    return write(stdout, put, 1);
    108e:	4605                	li	a2,1
    1090:	4501                	li	a0,0
    put[0] = c;
    1092:	00f58023          	sb	a5,0(a1)
    return write(stdout, put, 1);
    1096:	235000ef          	jal	ra,1aca <write>
}
    109a:	60a2                	ld	ra,8(sp)
    109c:	2501                	sext.w	a0,a0
    109e:	0141                	addi	sp,sp,16
    10a0:	8082                	ret

00000000000010a2 <puts>:

int puts(const char* s)
{
    10a2:	1141                	addi	sp,sp,-16
    10a4:	e022                	sd	s0,0(sp)
    10a6:	e406                	sd	ra,8(sp)
    10a8:	842a                	mv	s0,a0
    int r;
    r = -(write(stdout, s, strlen(s)) < 0 || putchar('\n') < 0);
    10aa:	658000ef          	jal	ra,1702 <strlen>
    10ae:	862a                	mv	a2,a0
    10b0:	85a2                	mv	a1,s0
    10b2:	4501                	li	a0,0
    10b4:	217000ef          	jal	ra,1aca <write>
    10b8:	00055763          	bgez	a0,10c6 <puts+0x24>
    return r;
}
    10bc:	60a2                	ld	ra,8(sp)
    10be:	6402                	ld	s0,0(sp)
    10c0:	557d                	li	a0,-1
    10c2:	0141                	addi	sp,sp,16
    10c4:	8082                	ret
    put[0] = c;
    10c6:	00001597          	auipc	a1,0x1
    10ca:	d2a58593          	addi	a1,a1,-726 # 1df0 <put.1058>
    10ce:	47a9                	li	a5,10
    return write(stdout, put, 1);
    10d0:	4605                	li	a2,1
    10d2:	4501                	li	a0,0
    put[0] = c;
    10d4:	00f58023          	sb	a5,0(a1)
    return write(stdout, put, 1);
    10d8:	1f3000ef          	jal	ra,1aca <write>
}
    10dc:	60a2                	ld	ra,8(sp)
    10de:	6402                	ld	s0,0(sp)
    10e0:	41f5551b          	sraiw	a0,a0,0x1f
    10e4:	0141                	addi	sp,sp,16
    10e6:	8082                	ret

00000000000010e8 <printf>:
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
        putchar(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(const char* fmt, ...) {
    10e8:	7131                	addi	sp,sp,-192
    10ea:	fc86                	sd	ra,120(sp)
    10ec:	f8a2                	sd	s0,112(sp)
    10ee:	f4a6                	sd	s1,104(sp)
    10f0:	f0ca                	sd	s2,96(sp)
    10f2:	ecce                	sd	s3,88(sp)
    10f4:	e8d2                	sd	s4,80(sp)
    10f6:	e4d6                	sd	s5,72(sp)
    10f8:	e0da                	sd	s6,64(sp)
    10fa:	fc5e                	sd	s7,56(sp)
    10fc:	f862                	sd	s8,48(sp)
    10fe:	f466                	sd	s9,40(sp)
    1100:	f06a                	sd	s10,32(sp)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1102:	00054303          	lbu	t1,0(a0)
void printf(const char* fmt, ...) {
    1106:	f53e                	sd	a5,168(sp)
    va_start(ap, fmt);
    1108:	013c                	addi	a5,sp,136
void printf(const char* fmt, ...) {
    110a:	e52e                	sd	a1,136(sp)
    110c:	e932                	sd	a2,144(sp)
    110e:	ed36                	sd	a3,152(sp)
    1110:	f13a                	sd	a4,160(sp)
    1112:	f942                	sd	a6,176(sp)
    1114:	fd46                	sd	a7,184(sp)
    va_start(ap, fmt);
    1116:	e43e                	sd	a5,8(sp)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1118:	0e030663          	beqz	t1,1204 <printf+0x11c>
    111c:	8a2a                	mv	s4,a0
    111e:	0003071b          	sext.w	a4,t1
    1122:	4901                	li	s2,0
        if (c != '%') {
    1124:	02500a93          	li	s5,37
            continue;
        }
        c = fmt[++i] & 0xff;
        if (c == 0)
            break;
        switch (c) {
    1128:	07000b93          	li	s7,112
    put[0] = c;
    112c:	00001417          	auipc	s0,0x1
    1130:	cc440413          	addi	s0,s0,-828 # 1df0 <put.1058>
    1134:	03000c93          	li	s9,48
    1138:	07800c13          	li	s8,120
    113c:	00001b17          	auipc	s6,0x1
    1140:	c2cb0b13          	addi	s6,s6,-980 # 1d68 <digits>
        if (c != '%') {
    1144:	0019079b          	addiw	a5,s2,1
    1148:	00fa09b3          	add	s3,s4,a5
    114c:	15571a63          	bne	a4,s5,12a0 <printf+0x1b8>
        c = fmt[++i] & 0xff;
    1150:	0009c483          	lbu	s1,0(s3)
        if (c == 0)
    1154:	c8c5                	beqz	s1,1204 <printf+0x11c>
        switch (c) {
    1156:	2909                	addiw	s2,s2,2
    1158:	012a09b3          	add	s3,s4,s2
    115c:	19748c63          	beq	s1,s7,12f4 <printf+0x20c>
    1160:	0c9be063          	bltu	s7,s1,1220 <printf+0x138>
    1164:	23548663          	beq	s1,s5,1390 <printf+0x2a8>
    1168:	06400793          	li	a5,100
    116c:	1ef49563          	bne	s1,a5,1356 <printf+0x26e>
            case 'd':
                printint(va_arg(ap, int), 10, 1);
    1170:	67a2                	ld	a5,8(sp)
    1172:	4394                	lw	a3,0(a5)
    1174:	07a1                	addi	a5,a5,8
    1176:	e43e                	sd	a5,8(sp)
    1178:	0ff6f793          	andi	a5,a3,255
    if (sign && (sign = xx < 0))
    117c:	0006d663          	bgez	a3,1188 <printf+0xa0>
        x = -xx;
    1180:	40f007bb          	negw	a5,a5
    1184:	0ff7f793          	andi	a5,a5,255
        buf[i++] = digits[x % base];
    1188:	4729                	li	a4,10
    118a:	02e7e63b          	remw	a2,a5,a4
    } while ((x /= base) != 0);
    118e:	02e7c4bb          	divw	s1,a5,a4
        buf[i++] = digits[x % base];
    1192:	965a                	add	a2,a2,s6
    1194:	00064603          	lbu	a2,0(a2)
    1198:	00c10823          	sb	a2,16(sp)
    } while ((x /= base) != 0);
    119c:	24048263          	beqz	s1,13e0 <printf+0x2f8>
        buf[i++] = digits[x % base];
    11a0:	02e4e63b          	remw	a2,s1,a4
    } while ((x /= base) != 0);
    11a4:	02e4c7bb          	divw	a5,s1,a4
        buf[i++] = digits[x % base];
    11a8:	00cb0733          	add	a4,s6,a2
    11ac:	00074703          	lbu	a4,0(a4)
    11b0:	00e108a3          	sb	a4,17(sp)
    } while ((x /= base) != 0);
    11b4:	22078863          	beqz	a5,13e4 <printf+0x2fc>
        buf[i++] = digits[x % base];
    11b8:	97da                	add	a5,a5,s6
    11ba:	0007c703          	lbu	a4,0(a5)
    11be:	4489                	li	s1,2
    11c0:	478d                	li	a5,3
    11c2:	00e10923          	sb	a4,18(sp)
    if (sign)
    11c6:	0006d963          	bgez	a3,11d8 <printf+0xf0>
        buf[i++] = '-';
    11ca:	1018                	addi	a4,sp,32
    11cc:	973e                	add	a4,a4,a5
    11ce:	02d00693          	li	a3,45
    11d2:	fed70823          	sb	a3,-16(a4)
        buf[i++] = digits[x % base];
    11d6:	84be                	mv	s1,a5
    while (--i >= 0)
    11d8:	081c                	addi	a5,sp,16
    11da:	94be                	add	s1,s1,a5
    11dc:	00f10d13          	addi	s10,sp,15
    put[0] = c;
    11e0:	0004c783          	lbu	a5,0(s1)
    return write(stdout, put, 1);
    11e4:	4605                	li	a2,1
    11e6:	14fd                	addi	s1,s1,-1
    11e8:	85a2                	mv	a1,s0
    11ea:	4501                	li	a0,0
    put[0] = c;
    11ec:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    11f0:	0db000ef          	jal	ra,1aca <write>
    while (--i >= 0)
    11f4:	ffa496e3          	bne	s1,s10,11e0 <printf+0xf8>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    11f8:	0009c303          	lbu	t1,0(s3)
    11fc:	0003071b          	sext.w	a4,t1
    1200:	f40312e3          	bnez	t1,1144 <printf+0x5c>
                putchar(c);
                break;
        }
    }
    va_end(ap);
    1204:	70e6                	ld	ra,120(sp)
    1206:	7446                	ld	s0,112(sp)
    1208:	74a6                	ld	s1,104(sp)
    120a:	7906                	ld	s2,96(sp)
    120c:	69e6                	ld	s3,88(sp)
    120e:	6a46                	ld	s4,80(sp)
    1210:	6aa6                	ld	s5,72(sp)
    1212:	6b06                	ld	s6,64(sp)
    1214:	7be2                	ld	s7,56(sp)
    1216:	7c42                	ld	s8,48(sp)
    1218:	7ca2                	ld	s9,40(sp)
    121a:	7d02                	ld	s10,32(sp)
    121c:	6129                	addi	sp,sp,192
    121e:	8082                	ret
        switch (c) {
    1220:	07300793          	li	a5,115
    1224:	0af48063          	beq	s1,a5,12c4 <printf+0x1dc>
    1228:	07800793          	li	a5,120
    122c:	12f49563          	bne	s1,a5,1356 <printf+0x26e>
                printint(va_arg(ap, int), 16, 1);
    1230:	67a2                	ld	a5,8(sp)
    1232:	4398                	lw	a4,0(a5)
    1234:	07a1                	addi	a5,a5,8
    1236:	e43e                	sd	a5,8(sp)
    1238:	0ff77793          	andi	a5,a4,255
    if (sign && (sign = xx < 0))
    123c:	16074b63          	bltz	a4,13b2 <printf+0x2ca>
        buf[i++] = digits[x % base];
    1240:	8bbd                	andi	a5,a5,15
    1242:	97da                	add	a5,a5,s6
    1244:	0007c783          	lbu	a5,0(a5)
    } while ((x /= base) != 0);
    1248:	4047549b          	sraiw	s1,a4,0x4
    124c:	88bd                	andi	s1,s1,15
        buf[i++] = digits[x % base];
    124e:	00f10823          	sb	a5,16(sp)
    } while ((x /= base) != 0);
    1252:	c085                	beqz	s1,1272 <printf+0x18a>
        buf[i++] = digits[x % base];
    1254:	94da                	add	s1,s1,s6
    1256:	0004c783          	lbu	a5,0(s1)
    125a:	4485                	li	s1,1
    125c:	00f108a3          	sb	a5,17(sp)
    if (sign)
    1260:	00075963          	bgez	a4,1272 <printf+0x18a>
        buf[i++] = digits[x % base];
    1264:	4489                	li	s1,2
        buf[i++] = '-';
    1266:	101c                	addi	a5,sp,32
    1268:	02d00713          	li	a4,45
    126c:	97a6                	add	a5,a5,s1
    126e:	fee78823          	sb	a4,-16(a5)
    while (--i >= 0)
    1272:	081c                	addi	a5,sp,16
    1274:	94be                	add	s1,s1,a5
    1276:	00f10d13          	addi	s10,sp,15
    put[0] = c;
    127a:	0004c783          	lbu	a5,0(s1)
    return write(stdout, put, 1);
    127e:	4605                	li	a2,1
    1280:	14fd                	addi	s1,s1,-1
    1282:	85a2                	mv	a1,s0
    1284:	4501                	li	a0,0
    put[0] = c;
    1286:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    128a:	041000ef          	jal	ra,1aca <write>
    while (--i >= 0)
    128e:	ffa496e3          	bne	s1,s10,127a <printf+0x192>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1292:	0009c303          	lbu	t1,0(s3)
    1296:	0003071b          	sext.w	a4,t1
    129a:	ea0315e3          	bnez	t1,1144 <printf+0x5c>
    129e:	b79d                	j	1204 <printf+0x11c>
    return write(stdout, put, 1);
    12a0:	4605                	li	a2,1
    12a2:	00001597          	auipc	a1,0x1
    12a6:	b4e58593          	addi	a1,a1,-1202 # 1df0 <put.1058>
    12aa:	4501                	li	a0,0
    put[0] = c;
    12ac:	00640023          	sb	t1,0(s0)
            continue;
    12b0:	893e                	mv	s2,a5
    return write(stdout, put, 1);
    12b2:	019000ef          	jal	ra,1aca <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    12b6:	0009c303          	lbu	t1,0(s3)
    12ba:	0003071b          	sext.w	a4,t1
    12be:	e80313e3          	bnez	t1,1144 <printf+0x5c>
    12c2:	b789                	j	1204 <printf+0x11c>
                if ((s = va_arg(ap, char *)) == 0)
    12c4:	67a2                	ld	a5,8(sp)
    12c6:	6384                	ld	s1,0(a5)
    12c8:	07a1                	addi	a5,a5,8
    12ca:	e43e                	sd	a5,8(sp)
    12cc:	e891                	bnez	s1,12e0 <printf+0x1f8>
    12ce:	a211                	j	13d2 <printf+0x2ea>
    return write(stdout, put, 1);
    12d0:	4605                	li	a2,1
    12d2:	85a2                	mv	a1,s0
    12d4:	4501                	li	a0,0
                for (; *s; s++)
    12d6:	0485                	addi	s1,s1,1
    put[0] = c;
    12d8:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    12dc:	7ee000ef          	jal	ra,1aca <write>
                for (; *s; s++)
    12e0:	0004c783          	lbu	a5,0(s1)
    12e4:	f7f5                	bnez	a5,12d0 <printf+0x1e8>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    12e6:	0009c303          	lbu	t1,0(s3)
    12ea:	0003071b          	sext.w	a4,t1
    12ee:	e4031be3          	bnez	t1,1144 <printf+0x5c>
    12f2:	bf09                	j	1204 <printf+0x11c>
                printptr(va_arg(ap, uint64));
    12f4:	67a2                	ld	a5,8(sp)
    return write(stdout, put, 1);
    12f6:	4605                	li	a2,1
    12f8:	00001597          	auipc	a1,0x1
    12fc:	af858593          	addi	a1,a1,-1288 # 1df0 <put.1058>
                printptr(va_arg(ap, uint64));
    1300:	00878713          	addi	a4,a5,8
    return write(stdout, put, 1);
    1304:	4501                	li	a0,0
                printptr(va_arg(ap, uint64));
    1306:	0007bd03          	ld	s10,0(a5)
    130a:	e43a                	sd	a4,8(sp)
    put[0] = c;
    130c:	01940023          	sb	s9,0(s0)
    return write(stdout, put, 1);
    1310:	7ba000ef          	jal	ra,1aca <write>
    1314:	4605                	li	a2,1
    1316:	00001597          	auipc	a1,0x1
    131a:	ada58593          	addi	a1,a1,-1318 # 1df0 <put.1058>
    131e:	4501                	li	a0,0
    put[0] = c;
    1320:	01840023          	sb	s8,0(s0)
    return write(stdout, put, 1);
    1324:	44c1                	li	s1,16
    1326:	7a4000ef          	jal	ra,1aca <write>
        putchar(digits[x >> (sizeof(uint64) * 8 - 4)]);
    132a:	03cd5793          	srli	a5,s10,0x3c
    132e:	97da                	add	a5,a5,s6
    put[0] = c;
    1330:	0007c783          	lbu	a5,0(a5)
    1334:	34fd                	addiw	s1,s1,-1
    return write(stdout, put, 1);
    1336:	4605                	li	a2,1
    1338:	85a2                	mv	a1,s0
    133a:	4501                	li	a0,0
    put[0] = c;
    133c:	00f40023          	sb	a5,0(s0)
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1340:	0d12                	slli	s10,s10,0x4
    return write(stdout, put, 1);
    1342:	788000ef          	jal	ra,1aca <write>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1346:	f0f5                	bnez	s1,132a <printf+0x242>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1348:	0009c303          	lbu	t1,0(s3)
    134c:	0003071b          	sext.w	a4,t1
    1350:	de031ae3          	bnez	t1,1144 <printf+0x5c>
    1354:	bd45                	j	1204 <printf+0x11c>
    put[0] = c;
    1356:	02500793          	li	a5,37
    return write(stdout, put, 1);
    135a:	4605                	li	a2,1
    135c:	00001597          	auipc	a1,0x1
    1360:	a9458593          	addi	a1,a1,-1388 # 1df0 <put.1058>
    1364:	4501                	li	a0,0
    put[0] = c;
    1366:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    136a:	760000ef          	jal	ra,1aca <write>
    136e:	4605                	li	a2,1
    1370:	00001597          	auipc	a1,0x1
    1374:	a8058593          	addi	a1,a1,-1408 # 1df0 <put.1058>
    1378:	4501                	li	a0,0
    put[0] = c;
    137a:	00940023          	sb	s1,0(s0)
    return write(stdout, put, 1);
    137e:	74c000ef          	jal	ra,1aca <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1382:	0009c303          	lbu	t1,0(s3)
    1386:	0003071b          	sext.w	a4,t1
    138a:	da031de3          	bnez	t1,1144 <printf+0x5c>
    138e:	bd9d                	j	1204 <printf+0x11c>
    return write(stdout, put, 1);
    1390:	4605                	li	a2,1
    1392:	00001597          	auipc	a1,0x1
    1396:	a5e58593          	addi	a1,a1,-1442 # 1df0 <put.1058>
    139a:	4501                	li	a0,0
    put[0] = c;
    139c:	01540023          	sb	s5,0(s0)
    return write(stdout, put, 1);
    13a0:	72a000ef          	jal	ra,1aca <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    13a4:	0009c303          	lbu	t1,0(s3)
    13a8:	0003071b          	sext.w	a4,t1
    13ac:	d8031ce3          	bnez	t1,1144 <printf+0x5c>
    13b0:	bd91                	j	1204 <printf+0x11c>
        x = -xx;
    13b2:	40f007bb          	negw	a5,a5
        buf[i++] = digits[x % base];
    13b6:	00f7f693          	andi	a3,a5,15
    13ba:	96da                	add	a3,a3,s6
    13bc:	0006c683          	lbu	a3,0(a3)
        x = -xx;
    13c0:	0ff7f493          	andi	s1,a5,255
    } while ((x /= base) != 0);
    13c4:	8091                	srli	s1,s1,0x4
        buf[i++] = digits[x % base];
    13c6:	00d10823          	sb	a3,16(sp)
    } while ((x /= base) != 0);
    13ca:	e80495e3          	bnez	s1,1254 <printf+0x16c>
        buf[i++] = digits[x % base];
    13ce:	4485                	li	s1,1
    13d0:	bd59                	j	1266 <printf+0x17e>
                s = "(null)";
    13d2:	00001497          	auipc	s1,0x1
    13d6:	96648493          	addi	s1,s1,-1690 # 1d38 <main+0x1da>
                for (; *s; s++)
    13da:	02800793          	li	a5,40
    13de:	bdcd                	j	12d0 <printf+0x1e8>
        buf[i++] = digits[x % base];
    13e0:	4785                	li	a5,1
    13e2:	b3d5                	j	11c6 <printf+0xde>
    13e4:	4789                	li	a5,2
    13e6:	4485                	li	s1,1
    13e8:	bbf9                	j	11c6 <printf+0xde>

00000000000013ea <srand>:
#include <unistd.h>

static uint64 seed;

void srand(unsigned s) {
    seed = s - 1;
    13ea:	357d                	addiw	a0,a0,-1
    13ec:	1502                	slli	a0,a0,0x20
    13ee:	9101                	srli	a0,a0,0x20
    13f0:	00001797          	auipc	a5,0x1
    13f4:	a0a7b423          	sd	a0,-1528(a5) # 1df8 <seed>
}
    13f8:	8082                	ret

00000000000013fa <rand>:

int rand(void) {
    seed = 6364136223846793005ULL * seed + 1;
    13fa:	00001797          	auipc	a5,0x1
    13fe:	9fe78793          	addi	a5,a5,-1538 # 1df8 <seed>
    1402:	6388                	ld	a0,0(a5)
    1404:	00001717          	auipc	a4,0x1
    1408:	94473703          	ld	a4,-1724(a4) # 1d48 <LF+0x5>
    140c:	02e50533          	mul	a0,a0,a4
    1410:	0505                	addi	a0,a0,1
    1412:	e388                	sd	a0,0(a5)
    return seed >> 33;
}
    1414:	9105                	srli	a0,a0,0x21
    1416:	8082                	ret

0000000000001418 <panic>:

void panic(char* m) {
    1418:	1141                	addi	sp,sp,-16
    141a:	e406                	sd	ra,8(sp)
    puts(m);
    141c:	c87ff0ef          	jal	ra,10a2 <puts>
    exit(-100);
}
    1420:	60a2                	ld	ra,8(sp)
    exit(-100);
    1422:	f9c00513          	li	a0,-100
}
    1426:	0141                	addi	sp,sp,16
    exit(-100);
    1428:	6d00006f          	j	1af8 <exit>

000000000000142c <assert>:

void assert(int f, int code) {
    if(!f) {
    142c:	c111                	beqz	a0,1430 <assert+0x4>
        exit(code);
    }
    142e:	8082                	ret
        exit(code);
    1430:	852e                	mv	a0,a1
    1432:	6c60006f          	j	1af8 <exit>

0000000000001436 <isspace>:
#define HIGHS      (ONES * (UCHAR_MAX / 2 + 1))
#define HASZERO(x) (((x)-ONES) & ~(x) & HIGHS)

int isspace(int c)
{
    return c == ' ' || (unsigned)c - '\t' < 5;
    1436:	02000793          	li	a5,32
    143a:	00f50663          	beq	a0,a5,1446 <isspace+0x10>
    143e:	355d                	addiw	a0,a0,-9
    1440:	00553513          	sltiu	a0,a0,5
    1444:	8082                	ret
    1446:	4505                	li	a0,1
}
    1448:	8082                	ret

000000000000144a <isdigit>:

int isdigit(int c)
{
    return (unsigned)c - '0' < 10;
    144a:	fd05051b          	addiw	a0,a0,-48
}
    144e:	00a53513          	sltiu	a0,a0,10
    1452:	8082                	ret

0000000000001454 <atoi>:
    return c == ' ' || (unsigned)c - '\t' < 5;
    1454:	02000613          	li	a2,32
    1458:	4591                	li	a1,4

int atoi(const char* s)
{
    int n = 0, neg = 0;
    while (isspace(*s))
    145a:	00054703          	lbu	a4,0(a0)
    return c == ' ' || (unsigned)c - '\t' < 5;
    145e:	ff77069b          	addiw	a3,a4,-9
    1462:	04c70d63          	beq	a4,a2,14bc <atoi+0x68>
    1466:	0007079b          	sext.w	a5,a4
    146a:	04d5f963          	bgeu	a1,a3,14bc <atoi+0x68>
        s++;
    switch (*s) {
    146e:	02b00693          	li	a3,43
    1472:	04d70a63          	beq	a4,a3,14c6 <atoi+0x72>
    1476:	02d00693          	li	a3,45
    147a:	06d70463          	beq	a4,a3,14e2 <atoi+0x8e>
        neg = 1;
    case '+':
        s++;
    }
    /* Compute n as a negative number to avoid overflow on INT_MIN */
    while (isdigit(*s))
    147e:	fd07859b          	addiw	a1,a5,-48
    1482:	4625                	li	a2,9
    1484:	873e                	mv	a4,a5
    1486:	86aa                	mv	a3,a0
    int n = 0, neg = 0;
    1488:	4e01                	li	t3,0
    while (isdigit(*s))
    148a:	04b66a63          	bltu	a2,a1,14de <atoi+0x8a>
    int n = 0, neg = 0;
    148e:	4501                	li	a0,0
    while (isdigit(*s))
    1490:	4825                	li	a6,9
    1492:	0016c603          	lbu	a2,1(a3)
        n = 10 * n - (*s++ - '0');
    1496:	0025179b          	slliw	a5,a0,0x2
    149a:	9d3d                	addw	a0,a0,a5
    149c:	fd07031b          	addiw	t1,a4,-48
    14a0:	0015189b          	slliw	a7,a0,0x1
    while (isdigit(*s))
    14a4:	fd06059b          	addiw	a1,a2,-48
        n = 10 * n - (*s++ - '0');
    14a8:	0685                	addi	a3,a3,1
    14aa:	4068853b          	subw	a0,a7,t1
    while (isdigit(*s))
    14ae:	0006071b          	sext.w	a4,a2
    14b2:	feb870e3          	bgeu	a6,a1,1492 <atoi+0x3e>
    return neg ? n : -n;
    14b6:	000e0563          	beqz	t3,14c0 <atoi+0x6c>
}
    14ba:	8082                	ret
        s++;
    14bc:	0505                	addi	a0,a0,1
    14be:	bf71                	j	145a <atoi+0x6>
    14c0:	4113053b          	subw	a0,t1,a7
    14c4:	8082                	ret
    while (isdigit(*s))
    14c6:	00154783          	lbu	a5,1(a0)
    14ca:	4625                	li	a2,9
        s++;
    14cc:	00150693          	addi	a3,a0,1
    while (isdigit(*s))
    14d0:	fd07859b          	addiw	a1,a5,-48
    14d4:	0007871b          	sext.w	a4,a5
    int n = 0, neg = 0;
    14d8:	4e01                	li	t3,0
    while (isdigit(*s))
    14da:	fab67ae3          	bgeu	a2,a1,148e <atoi+0x3a>
    14de:	4501                	li	a0,0
}
    14e0:	8082                	ret
    while (isdigit(*s))
    14e2:	00154783          	lbu	a5,1(a0)
    14e6:	4625                	li	a2,9
        s++;
    14e8:	00150693          	addi	a3,a0,1
    while (isdigit(*s))
    14ec:	fd07859b          	addiw	a1,a5,-48
    14f0:	0007871b          	sext.w	a4,a5
    14f4:	feb665e3          	bltu	a2,a1,14de <atoi+0x8a>
        neg = 1;
    14f8:	4e05                	li	t3,1
    14fa:	bf51                	j	148e <atoi+0x3a>

00000000000014fc <memset>:

void* memset(void* dest, int c, size_t n)
{
    char* p = dest;
    for(int i = 0; i < n; ++i, *(p++) = c);
    14fc:	16060d63          	beqz	a2,1676 <memset+0x17a>
    1500:	40a007b3          	neg	a5,a0
    1504:	8b9d                	andi	a5,a5,7
    1506:	00778713          	addi	a4,a5,7
    150a:	482d                	li	a6,11
    150c:	0ff5f593          	andi	a1,a1,255
    1510:	fff60693          	addi	a3,a2,-1
    1514:	17076263          	bltu	a4,a6,1678 <memset+0x17c>
    1518:	16e6ea63          	bltu	a3,a4,168c <memset+0x190>
    151c:	16078563          	beqz	a5,1686 <memset+0x18a>
    1520:	00b50023          	sb	a1,0(a0)
    1524:	4705                	li	a4,1
    1526:	00150e93          	addi	t4,a0,1
    152a:	14e78c63          	beq	a5,a4,1682 <memset+0x186>
    152e:	00b500a3          	sb	a1,1(a0)
    1532:	4709                	li	a4,2
    1534:	00250e93          	addi	t4,a0,2
    1538:	14e78d63          	beq	a5,a4,1692 <memset+0x196>
    153c:	00b50123          	sb	a1,2(a0)
    1540:	470d                	li	a4,3
    1542:	00350e93          	addi	t4,a0,3
    1546:	12e78b63          	beq	a5,a4,167c <memset+0x180>
    154a:	00b501a3          	sb	a1,3(a0)
    154e:	4711                	li	a4,4
    1550:	00450e93          	addi	t4,a0,4
    1554:	14e78163          	beq	a5,a4,1696 <memset+0x19a>
    1558:	00b50223          	sb	a1,4(a0)
    155c:	4715                	li	a4,5
    155e:	00550e93          	addi	t4,a0,5
    1562:	12e78c63          	beq	a5,a4,169a <memset+0x19e>
    1566:	00b502a3          	sb	a1,5(a0)
    156a:	471d                	li	a4,7
    156c:	00650e93          	addi	t4,a0,6
    1570:	12e79763          	bne	a5,a4,169e <memset+0x1a2>
    1574:	00750e93          	addi	t4,a0,7
    1578:	00b50323          	sb	a1,6(a0)
    157c:	4f1d                	li	t5,7
    157e:	00859713          	slli	a4,a1,0x8
    1582:	8f4d                	or	a4,a4,a1
    1584:	01059e13          	slli	t3,a1,0x10
    1588:	01c76e33          	or	t3,a4,t3
    158c:	01859313          	slli	t1,a1,0x18
    1590:	006e6333          	or	t1,t3,t1
    1594:	02059893          	slli	a7,a1,0x20
    1598:	011368b3          	or	a7,t1,a7
    159c:	02859813          	slli	a6,a1,0x28
    15a0:	40f60333          	sub	t1,a2,a5
    15a4:	0108e833          	or	a6,a7,a6
    15a8:	03059693          	slli	a3,a1,0x30
    15ac:	00d866b3          	or	a3,a6,a3
    15b0:	03859713          	slli	a4,a1,0x38
    15b4:	97aa                	add	a5,a5,a0
    15b6:	ff837813          	andi	a6,t1,-8
    15ba:	8f55                	or	a4,a4,a3
    15bc:	00f806b3          	add	a3,a6,a5
    15c0:	e398                	sd	a4,0(a5)
    15c2:	07a1                	addi	a5,a5,8
    15c4:	fed79ee3          	bne	a5,a3,15c0 <memset+0xc4>
    15c8:	ff837693          	andi	a3,t1,-8
    15cc:	00de87b3          	add	a5,t4,a3
    15d0:	01e6873b          	addw	a4,a3,t5
    15d4:	0ad30663          	beq	t1,a3,1680 <memset+0x184>
    15d8:	00b78023          	sb	a1,0(a5)
    15dc:	0017069b          	addiw	a3,a4,1
    15e0:	08c6fb63          	bgeu	a3,a2,1676 <memset+0x17a>
    15e4:	00b780a3          	sb	a1,1(a5)
    15e8:	0027069b          	addiw	a3,a4,2
    15ec:	08c6f563          	bgeu	a3,a2,1676 <memset+0x17a>
    15f0:	00b78123          	sb	a1,2(a5)
    15f4:	0037069b          	addiw	a3,a4,3
    15f8:	06c6ff63          	bgeu	a3,a2,1676 <memset+0x17a>
    15fc:	00b781a3          	sb	a1,3(a5)
    1600:	0047069b          	addiw	a3,a4,4
    1604:	06c6f963          	bgeu	a3,a2,1676 <memset+0x17a>
    1608:	00b78223          	sb	a1,4(a5)
    160c:	0057069b          	addiw	a3,a4,5
    1610:	06c6f363          	bgeu	a3,a2,1676 <memset+0x17a>
    1614:	00b782a3          	sb	a1,5(a5)
    1618:	0067069b          	addiw	a3,a4,6
    161c:	04c6fd63          	bgeu	a3,a2,1676 <memset+0x17a>
    1620:	00b78323          	sb	a1,6(a5)
    1624:	0077069b          	addiw	a3,a4,7
    1628:	04c6f763          	bgeu	a3,a2,1676 <memset+0x17a>
    162c:	00b783a3          	sb	a1,7(a5)
    1630:	0087069b          	addiw	a3,a4,8
    1634:	04c6f163          	bgeu	a3,a2,1676 <memset+0x17a>
    1638:	00b78423          	sb	a1,8(a5)
    163c:	0097069b          	addiw	a3,a4,9
    1640:	02c6fb63          	bgeu	a3,a2,1676 <memset+0x17a>
    1644:	00b784a3          	sb	a1,9(a5)
    1648:	00a7069b          	addiw	a3,a4,10
    164c:	02c6f563          	bgeu	a3,a2,1676 <memset+0x17a>
    1650:	00b78523          	sb	a1,10(a5)
    1654:	00b7069b          	addiw	a3,a4,11
    1658:	00c6ff63          	bgeu	a3,a2,1676 <memset+0x17a>
    165c:	00b785a3          	sb	a1,11(a5)
    1660:	00c7069b          	addiw	a3,a4,12
    1664:	00c6f963          	bgeu	a3,a2,1676 <memset+0x17a>
    1668:	00b78623          	sb	a1,12(a5)
    166c:	2735                	addiw	a4,a4,13
    166e:	00c77463          	bgeu	a4,a2,1676 <memset+0x17a>
    1672:	00b786a3          	sb	a1,13(a5)
    return dest;
}
    1676:	8082                	ret
    1678:	472d                	li	a4,11
    167a:	bd79                	j	1518 <memset+0x1c>
    for(int i = 0; i < n; ++i, *(p++) = c);
    167c:	4f0d                	li	t5,3
    167e:	b701                	j	157e <memset+0x82>
    1680:	8082                	ret
    1682:	4f05                	li	t5,1
    1684:	bded                	j	157e <memset+0x82>
    1686:	8eaa                	mv	t4,a0
    1688:	4f01                	li	t5,0
    168a:	bdd5                	j	157e <memset+0x82>
    168c:	87aa                	mv	a5,a0
    168e:	4701                	li	a4,0
    1690:	b7a1                	j	15d8 <memset+0xdc>
    1692:	4f09                	li	t5,2
    1694:	b5ed                	j	157e <memset+0x82>
    1696:	4f11                	li	t5,4
    1698:	b5dd                	j	157e <memset+0x82>
    169a:	4f15                	li	t5,5
    169c:	b5cd                	j	157e <memset+0x82>
    169e:	4f19                	li	t5,6
    16a0:	bdf9                	j	157e <memset+0x82>

00000000000016a2 <strcmp>:

int strcmp(const char* l, const char* r)
{
    for (; *l == *r && *l; l++, r++)
    16a2:	00054783          	lbu	a5,0(a0)
    16a6:	0005c703          	lbu	a4,0(a1)
    16aa:	00e79863          	bne	a5,a4,16ba <strcmp+0x18>
    16ae:	0505                	addi	a0,a0,1
    16b0:	0585                	addi	a1,a1,1
    16b2:	fbe5                	bnez	a5,16a2 <strcmp>
    16b4:	4501                	li	a0,0
        ;
    return *(unsigned char*)l - *(unsigned char*)r;
}
    16b6:	9d19                	subw	a0,a0,a4
    16b8:	8082                	ret
    16ba:	0007851b          	sext.w	a0,a5
    16be:	bfe5                	j	16b6 <strcmp+0x14>

00000000000016c0 <strncmp>:

int strncmp(const char* _l, const char* _r, size_t n)
{
    const unsigned char *l = (void*)_l, *r = (void*)_r;
    if (!n--)
    16c0:	ce05                	beqz	a2,16f8 <strncmp+0x38>
        return 0;
    for (; *l && *r && n && *l == *r; l++, r++, n--)
    16c2:	00054703          	lbu	a4,0(a0)
    16c6:	0005c783          	lbu	a5,0(a1)
    16ca:	cb0d                	beqz	a4,16fc <strncmp+0x3c>
    if (!n--)
    16cc:	167d                	addi	a2,a2,-1
    16ce:	00c506b3          	add	a3,a0,a2
    16d2:	a819                	j	16e8 <strncmp+0x28>
    for (; *l && *r && n && *l == *r; l++, r++, n--)
    16d4:	00a68e63          	beq	a3,a0,16f0 <strncmp+0x30>
    16d8:	0505                	addi	a0,a0,1
    16da:	00e79b63          	bne	a5,a4,16f0 <strncmp+0x30>
    16de:	00054703          	lbu	a4,0(a0)
    16e2:	0005c783          	lbu	a5,0(a1)
    16e6:	cb19                	beqz	a4,16fc <strncmp+0x3c>
    16e8:	0005c783          	lbu	a5,0(a1)
    16ec:	0585                	addi	a1,a1,1
    16ee:	f3fd                	bnez	a5,16d4 <strncmp+0x14>
        ;
    return *l - *r;
    16f0:	0007051b          	sext.w	a0,a4
    16f4:	9d1d                	subw	a0,a0,a5
    16f6:	8082                	ret
        return 0;
    16f8:	4501                	li	a0,0
}
    16fa:	8082                	ret
    16fc:	4501                	li	a0,0
    return *l - *r;
    16fe:	9d1d                	subw	a0,a0,a5
    1700:	8082                	ret

0000000000001702 <strlen>:
size_t strlen(const char* s)
{
    const char* a = s;
    typedef size_t __attribute__((__may_alias__)) word;
    const word* w;
    for (; (uintptr_t)s % SS; s++)
    1702:	00757793          	andi	a5,a0,7
    1706:	cf89                	beqz	a5,1720 <strlen+0x1e>
    1708:	87aa                	mv	a5,a0
    170a:	a029                	j	1714 <strlen+0x12>
    170c:	0785                	addi	a5,a5,1
    170e:	0077f713          	andi	a4,a5,7
    1712:	cb01                	beqz	a4,1722 <strlen+0x20>
        if (!*s)
    1714:	0007c703          	lbu	a4,0(a5)
    1718:	fb75                	bnez	a4,170c <strlen+0xa>
    for (w = (const void*)s; !HASZERO(*w); w++)
        ;
    s = (const void*)w;
    for (; *s; s++)
        ;
    return s - a;
    171a:	40a78533          	sub	a0,a5,a0
}
    171e:	8082                	ret
    for (; (uintptr_t)s % SS; s++)
    1720:	87aa                	mv	a5,a0
    for (w = (const void*)s; !HASZERO(*w); w++)
    1722:	6394                	ld	a3,0(a5)
    1724:	00000597          	auipc	a1,0x0
    1728:	62c5b583          	ld	a1,1580(a1) # 1d50 <LF+0xd>
    172c:	00000617          	auipc	a2,0x0
    1730:	62c63603          	ld	a2,1580(a2) # 1d58 <LF+0x15>
    1734:	a019                	j	173a <strlen+0x38>
    1736:	6794                	ld	a3,8(a5)
    1738:	07a1                	addi	a5,a5,8
    173a:	00b68733          	add	a4,a3,a1
    173e:	fff6c693          	not	a3,a3
    1742:	8f75                	and	a4,a4,a3
    1744:	8f71                	and	a4,a4,a2
    1746:	db65                	beqz	a4,1736 <strlen+0x34>
    for (; *s; s++)
    1748:	0007c703          	lbu	a4,0(a5)
    174c:	d779                	beqz	a4,171a <strlen+0x18>
    174e:	0017c703          	lbu	a4,1(a5)
    1752:	0785                	addi	a5,a5,1
    1754:	d379                	beqz	a4,171a <strlen+0x18>
    1756:	0017c703          	lbu	a4,1(a5)
    175a:	0785                	addi	a5,a5,1
    175c:	fb6d                	bnez	a4,174e <strlen+0x4c>
    175e:	bf75                	j	171a <strlen+0x18>

0000000000001760 <memchr>:

void* memchr(const void* src, int c, size_t n)
{
    const unsigned char* s = src;
    c = (unsigned char)c;
    for (; ((uintptr_t)s & ALIGN) && n && *s != c; s++, n--)
    1760:	00757713          	andi	a4,a0,7
{
    1764:	87aa                	mv	a5,a0
    c = (unsigned char)c;
    1766:	0ff5f593          	andi	a1,a1,255
    for (; ((uintptr_t)s & ALIGN) && n && *s != c; s++, n--)
    176a:	cb19                	beqz	a4,1780 <memchr+0x20>
    176c:	ce25                	beqz	a2,17e4 <memchr+0x84>
    176e:	0007c703          	lbu	a4,0(a5)
    1772:	04b70e63          	beq	a4,a1,17ce <memchr+0x6e>
    1776:	0785                	addi	a5,a5,1
    1778:	0077f713          	andi	a4,a5,7
    177c:	167d                	addi	a2,a2,-1
    177e:	f77d                	bnez	a4,176c <memchr+0xc>
            ;
        s = (const void*)w;
    }
    for (; n && *s != c; s++, n--)
        ;
    return n ? (void*)s : 0;
    1780:	4501                	li	a0,0
    if (n && *s != c) {
    1782:	c235                	beqz	a2,17e6 <memchr+0x86>
    1784:	0007c703          	lbu	a4,0(a5)
    1788:	04b70363          	beq	a4,a1,17ce <memchr+0x6e>
        size_t k = ONES * c;
    178c:	00000517          	auipc	a0,0x0
    1790:	5d453503          	ld	a0,1492(a0) # 1d60 <LF+0x1d>
        for (w = (const void*)s; n >= SS && !HASZERO(*w ^ k); w++, n -= SS)
    1794:	471d                	li	a4,7
        size_t k = ONES * c;
    1796:	02a58533          	mul	a0,a1,a0
        for (w = (const void*)s; n >= SS && !HASZERO(*w ^ k); w++, n -= SS)
    179a:	02c77a63          	bgeu	a4,a2,17ce <memchr+0x6e>
    179e:	00000897          	auipc	a7,0x0
    17a2:	5b28b883          	ld	a7,1458(a7) # 1d50 <LF+0xd>
    17a6:	00000817          	auipc	a6,0x0
    17aa:	5b283803          	ld	a6,1458(a6) # 1d58 <LF+0x15>
    17ae:	431d                	li	t1,7
    17b0:	a029                	j	17ba <memchr+0x5a>
    17b2:	1661                	addi	a2,a2,-8
    17b4:	07a1                	addi	a5,a5,8
    17b6:	02c37963          	bgeu	t1,a2,17e8 <memchr+0x88>
    17ba:	6398                	ld	a4,0(a5)
    17bc:	8f29                	xor	a4,a4,a0
    17be:	011706b3          	add	a3,a4,a7
    17c2:	fff74713          	not	a4,a4
    17c6:	8f75                	and	a4,a4,a3
    17c8:	01077733          	and	a4,a4,a6
    17cc:	d37d                	beqz	a4,17b2 <memchr+0x52>
    17ce:	853e                	mv	a0,a5
    17d0:	97b2                	add	a5,a5,a2
    17d2:	a021                	j	17da <memchr+0x7a>
    for (; n && *s != c; s++, n--)
    17d4:	0505                	addi	a0,a0,1
    17d6:	00f50763          	beq	a0,a5,17e4 <memchr+0x84>
    17da:	00054703          	lbu	a4,0(a0)
    17de:	feb71be3          	bne	a4,a1,17d4 <memchr+0x74>
    17e2:	8082                	ret
    return n ? (void*)s : 0;
    17e4:	4501                	li	a0,0
}
    17e6:	8082                	ret
    return n ? (void*)s : 0;
    17e8:	4501                	li	a0,0
    for (; n && *s != c; s++, n--)
    17ea:	f275                	bnez	a2,17ce <memchr+0x6e>
}
    17ec:	8082                	ret

00000000000017ee <strnlen>:

size_t strnlen(const char* s, size_t n)
{
    17ee:	1101                	addi	sp,sp,-32
    17f0:	e822                	sd	s0,16(sp)
    const char* p = memchr(s, 0, n);
    17f2:	862e                	mv	a2,a1
{
    17f4:	842e                	mv	s0,a1
    const char* p = memchr(s, 0, n);
    17f6:	4581                	li	a1,0
{
    17f8:	e426                	sd	s1,8(sp)
    17fa:	ec06                	sd	ra,24(sp)
    17fc:	84aa                	mv	s1,a0
    const char* p = memchr(s, 0, n);
    17fe:	f63ff0ef          	jal	ra,1760 <memchr>
    return p ? p - s : n;
    1802:	c519                	beqz	a0,1810 <strnlen+0x22>
}
    1804:	60e2                	ld	ra,24(sp)
    1806:	6442                	ld	s0,16(sp)
    return p ? p - s : n;
    1808:	8d05                	sub	a0,a0,s1
}
    180a:	64a2                	ld	s1,8(sp)
    180c:	6105                	addi	sp,sp,32
    180e:	8082                	ret
    1810:	60e2                	ld	ra,24(sp)
    return p ? p - s : n;
    1812:	8522                	mv	a0,s0
}
    1814:	6442                	ld	s0,16(sp)
    1816:	64a2                	ld	s1,8(sp)
    1818:	6105                	addi	sp,sp,32
    181a:	8082                	ret

000000000000181c <stpcpy>:
char* stpcpy(char* restrict d, const char* s)
{
    typedef size_t __attribute__((__may_alias__)) word;
    word* wd;
    const word* ws;
    if ((uintptr_t)s % SS == (uintptr_t)d % SS) {
    181c:	00b547b3          	xor	a5,a0,a1
    1820:	8b9d                	andi	a5,a5,7
    1822:	eb95                	bnez	a5,1856 <stpcpy+0x3a>
        for (; (uintptr_t)s % SS; s++, d++)
    1824:	0075f793          	andi	a5,a1,7
    1828:	e7b1                	bnez	a5,1874 <stpcpy+0x58>
            if (!(*d = *s))
                return d;
        wd = (void*)d;
        ws = (const void*)s;
        for (; !HASZERO(*ws); *wd++ = *ws++)
    182a:	6198                	ld	a4,0(a1)
    182c:	00000617          	auipc	a2,0x0
    1830:	52463603          	ld	a2,1316(a2) # 1d50 <LF+0xd>
    1834:	00000817          	auipc	a6,0x0
    1838:	52483803          	ld	a6,1316(a6) # 1d58 <LF+0x15>
    183c:	a029                	j	1846 <stpcpy+0x2a>
    183e:	e118                	sd	a4,0(a0)
    1840:	6598                	ld	a4,8(a1)
    1842:	05a1                	addi	a1,a1,8
    1844:	0521                	addi	a0,a0,8
    1846:	00c707b3          	add	a5,a4,a2
    184a:	fff74693          	not	a3,a4
    184e:	8ff5                	and	a5,a5,a3
    1850:	0107f7b3          	and	a5,a5,a6
    1854:	d7ed                	beqz	a5,183e <stpcpy+0x22>
            ;
        d = (void*)wd;
        s = (const void*)ws;
    }
    for (; (*d = *s); s++, d++)
    1856:	0005c783          	lbu	a5,0(a1)
    185a:	00f50023          	sb	a5,0(a0)
    185e:	c785                	beqz	a5,1886 <stpcpy+0x6a>
    1860:	0015c783          	lbu	a5,1(a1)
    1864:	0505                	addi	a0,a0,1
    1866:	0585                	addi	a1,a1,1
    1868:	00f50023          	sb	a5,0(a0)
    186c:	fbf5                	bnez	a5,1860 <stpcpy+0x44>
        ;
    return d;
}
    186e:	8082                	ret
        for (; (uintptr_t)s % SS; s++, d++)
    1870:	0505                	addi	a0,a0,1
    1872:	df45                	beqz	a4,182a <stpcpy+0xe>
            if (!(*d = *s))
    1874:	0005c783          	lbu	a5,0(a1)
        for (; (uintptr_t)s % SS; s++, d++)
    1878:	0585                	addi	a1,a1,1
    187a:	0075f713          	andi	a4,a1,7
            if (!(*d = *s))
    187e:	00f50023          	sb	a5,0(a0)
    1882:	f7fd                	bnez	a5,1870 <stpcpy+0x54>
}
    1884:	8082                	ret
    1886:	8082                	ret

0000000000001888 <stpncpy>:
char* stpncpy(char* restrict d, const char* s, size_t n)
{
    typedef size_t __attribute__((__may_alias__)) word;
    word* wd;
    const word* ws;
    if (((uintptr_t)s & ALIGN) == ((uintptr_t)d & ALIGN)) {
    1888:	00b547b3          	xor	a5,a0,a1
    188c:	8b9d                	andi	a5,a5,7
    188e:	1a079863          	bnez	a5,1a3e <stpncpy+0x1b6>
        for (; ((uintptr_t)s & ALIGN) && n && (*d = *s); n--, s++, d++)
    1892:	0075f793          	andi	a5,a1,7
    1896:	16078463          	beqz	a5,19fe <stpncpy+0x176>
    189a:	ea01                	bnez	a2,18aa <stpncpy+0x22>
    189c:	a421                	j	1aa4 <stpncpy+0x21c>
    189e:	167d                	addi	a2,a2,-1
    18a0:	0505                	addi	a0,a0,1
    18a2:	14070e63          	beqz	a4,19fe <stpncpy+0x176>
    18a6:	1a060863          	beqz	a2,1a56 <stpncpy+0x1ce>
    18aa:	0005c783          	lbu	a5,0(a1)
    18ae:	0585                	addi	a1,a1,1
    18b0:	0075f713          	andi	a4,a1,7
    18b4:	00f50023          	sb	a5,0(a0)
    18b8:	f3fd                	bnez	a5,189e <stpncpy+0x16>
    18ba:	4805                	li	a6,1
    18bc:	1a061863          	bnez	a2,1a6c <stpncpy+0x1e4>
    18c0:	40a007b3          	neg	a5,a0
    18c4:	8b9d                	andi	a5,a5,7
    18c6:	4681                	li	a3,0
    18c8:	18061a63          	bnez	a2,1a5c <stpncpy+0x1d4>
    18cc:	00778713          	addi	a4,a5,7
    18d0:	45ad                	li	a1,11
    18d2:	18b76363          	bltu	a4,a1,1a58 <stpncpy+0x1d0>
    18d6:	1ae6eb63          	bltu	a3,a4,1a8c <stpncpy+0x204>
    18da:	1a078363          	beqz	a5,1a80 <stpncpy+0x1f8>
    for(int i = 0; i < n; ++i, *(p++) = c);
    18de:	00050023          	sb	zero,0(a0)
    18e2:	4685                	li	a3,1
    18e4:	00150713          	addi	a4,a0,1
    18e8:	18d78f63          	beq	a5,a3,1a86 <stpncpy+0x1fe>
    18ec:	000500a3          	sb	zero,1(a0)
    18f0:	4689                	li	a3,2
    18f2:	00250713          	addi	a4,a0,2
    18f6:	18d78e63          	beq	a5,a3,1a92 <stpncpy+0x20a>
    18fa:	00050123          	sb	zero,2(a0)
    18fe:	468d                	li	a3,3
    1900:	00350713          	addi	a4,a0,3
    1904:	16d78c63          	beq	a5,a3,1a7c <stpncpy+0x1f4>
    1908:	000501a3          	sb	zero,3(a0)
    190c:	4691                	li	a3,4
    190e:	00450713          	addi	a4,a0,4
    1912:	18d78263          	beq	a5,a3,1a96 <stpncpy+0x20e>
    1916:	00050223          	sb	zero,4(a0)
    191a:	4695                	li	a3,5
    191c:	00550713          	addi	a4,a0,5
    1920:	16d78d63          	beq	a5,a3,1a9a <stpncpy+0x212>
    1924:	000502a3          	sb	zero,5(a0)
    1928:	469d                	li	a3,7
    192a:	00650713          	addi	a4,a0,6
    192e:	16d79863          	bne	a5,a3,1a9e <stpncpy+0x216>
    1932:	00750713          	addi	a4,a0,7
    1936:	00050323          	sb	zero,6(a0)
    193a:	40f80833          	sub	a6,a6,a5
    193e:	ff887593          	andi	a1,a6,-8
    1942:	97aa                	add	a5,a5,a0
    1944:	95be                	add	a1,a1,a5
    1946:	0007b023          	sd	zero,0(a5)
    194a:	07a1                	addi	a5,a5,8
    194c:	feb79de3          	bne	a5,a1,1946 <stpncpy+0xbe>
    1950:	ff887593          	andi	a1,a6,-8
    1954:	9ead                	addw	a3,a3,a1
    1956:	00b707b3          	add	a5,a4,a1
    195a:	12b80863          	beq	a6,a1,1a8a <stpncpy+0x202>
    195e:	00078023          	sb	zero,0(a5)
    1962:	0016871b          	addiw	a4,a3,1
    1966:	0ec77863          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    196a:	000780a3          	sb	zero,1(a5)
    196e:	0026871b          	addiw	a4,a3,2
    1972:	0ec77263          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    1976:	00078123          	sb	zero,2(a5)
    197a:	0036871b          	addiw	a4,a3,3
    197e:	0cc77c63          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    1982:	000781a3          	sb	zero,3(a5)
    1986:	0046871b          	addiw	a4,a3,4
    198a:	0cc77663          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    198e:	00078223          	sb	zero,4(a5)
    1992:	0056871b          	addiw	a4,a3,5
    1996:	0cc77063          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    199a:	000782a3          	sb	zero,5(a5)
    199e:	0066871b          	addiw	a4,a3,6
    19a2:	0ac77a63          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19a6:	00078323          	sb	zero,6(a5)
    19aa:	0076871b          	addiw	a4,a3,7
    19ae:	0ac77463          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19b2:	000783a3          	sb	zero,7(a5)
    19b6:	0086871b          	addiw	a4,a3,8
    19ba:	08c77e63          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19be:	00078423          	sb	zero,8(a5)
    19c2:	0096871b          	addiw	a4,a3,9
    19c6:	08c77863          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19ca:	000784a3          	sb	zero,9(a5)
    19ce:	00a6871b          	addiw	a4,a3,10
    19d2:	08c77263          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19d6:	00078523          	sb	zero,10(a5)
    19da:	00b6871b          	addiw	a4,a3,11
    19de:	06c77c63          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19e2:	000785a3          	sb	zero,11(a5)
    19e6:	00c6871b          	addiw	a4,a3,12
    19ea:	06c77663          	bgeu	a4,a2,1a56 <stpncpy+0x1ce>
    19ee:	00078623          	sb	zero,12(a5)
    19f2:	26b5                	addiw	a3,a3,13
    19f4:	06c6f163          	bgeu	a3,a2,1a56 <stpncpy+0x1ce>
    19f8:	000786a3          	sb	zero,13(a5)
    19fc:	8082                	ret
            ;
        if (!n || !*s)
    19fe:	c645                	beqz	a2,1aa6 <stpncpy+0x21e>
    1a00:	0005c783          	lbu	a5,0(a1)
    1a04:	ea078be3          	beqz	a5,18ba <stpncpy+0x32>
            goto tail;
        wd = (void*)d;
        ws = (const void*)s;
        for (; n >= sizeof(size_t) && !HASZERO(*ws); n -= sizeof(size_t), ws++, wd++)
    1a08:	479d                	li	a5,7
    1a0a:	02c7ff63          	bgeu	a5,a2,1a48 <stpncpy+0x1c0>
    1a0e:	00000897          	auipc	a7,0x0
    1a12:	3428b883          	ld	a7,834(a7) # 1d50 <LF+0xd>
    1a16:	00000817          	auipc	a6,0x0
    1a1a:	34283803          	ld	a6,834(a6) # 1d58 <LF+0x15>
    1a1e:	431d                	li	t1,7
    1a20:	6198                	ld	a4,0(a1)
    1a22:	011707b3          	add	a5,a4,a7
    1a26:	fff74693          	not	a3,a4
    1a2a:	8ff5                	and	a5,a5,a3
    1a2c:	0107f7b3          	and	a5,a5,a6
    1a30:	ef81                	bnez	a5,1a48 <stpncpy+0x1c0>
            *wd = *ws;
    1a32:	e118                	sd	a4,0(a0)
        for (; n >= sizeof(size_t) && !HASZERO(*ws); n -= sizeof(size_t), ws++, wd++)
    1a34:	1661                	addi	a2,a2,-8
    1a36:	05a1                	addi	a1,a1,8
    1a38:	0521                	addi	a0,a0,8
    1a3a:	fec363e3          	bltu	t1,a2,1a20 <stpncpy+0x198>
        d = (void*)wd;
        s = (const void*)ws;
    }
    for (; n && (*d = *s); n--, s++, d++)
    1a3e:	e609                	bnez	a2,1a48 <stpncpy+0x1c0>
    1a40:	a08d                	j	1aa2 <stpncpy+0x21a>
    1a42:	167d                	addi	a2,a2,-1
    1a44:	0505                	addi	a0,a0,1
    1a46:	ca01                	beqz	a2,1a56 <stpncpy+0x1ce>
    1a48:	0005c783          	lbu	a5,0(a1)
    1a4c:	0585                	addi	a1,a1,1
    1a4e:	00f50023          	sb	a5,0(a0)
    1a52:	fbe5                	bnez	a5,1a42 <stpncpy+0x1ba>
        ;
tail:
    1a54:	b59d                	j	18ba <stpncpy+0x32>
    memset(d, 0, n);
    return d;
    1a56:	8082                	ret
    1a58:	472d                	li	a4,11
    1a5a:	bdb5                	j	18d6 <stpncpy+0x4e>
    1a5c:	00778713          	addi	a4,a5,7
    1a60:	45ad                	li	a1,11
    1a62:	fff60693          	addi	a3,a2,-1
    1a66:	e6b778e3          	bgeu	a4,a1,18d6 <stpncpy+0x4e>
    1a6a:	b7fd                	j	1a58 <stpncpy+0x1d0>
    1a6c:	40a007b3          	neg	a5,a0
    1a70:	8832                	mv	a6,a2
    1a72:	8b9d                	andi	a5,a5,7
    1a74:	4681                	li	a3,0
    1a76:	e4060be3          	beqz	a2,18cc <stpncpy+0x44>
    1a7a:	b7cd                	j	1a5c <stpncpy+0x1d4>
    for(int i = 0; i < n; ++i, *(p++) = c);
    1a7c:	468d                	li	a3,3
    1a7e:	bd75                	j	193a <stpncpy+0xb2>
    1a80:	872a                	mv	a4,a0
    1a82:	4681                	li	a3,0
    1a84:	bd5d                	j	193a <stpncpy+0xb2>
    1a86:	4685                	li	a3,1
    1a88:	bd4d                	j	193a <stpncpy+0xb2>
    1a8a:	8082                	ret
    1a8c:	87aa                	mv	a5,a0
    1a8e:	4681                	li	a3,0
    1a90:	b5f9                	j	195e <stpncpy+0xd6>
    1a92:	4689                	li	a3,2
    1a94:	b55d                	j	193a <stpncpy+0xb2>
    1a96:	4691                	li	a3,4
    1a98:	b54d                	j	193a <stpncpy+0xb2>
    1a9a:	4695                	li	a3,5
    1a9c:	bd79                	j	193a <stpncpy+0xb2>
    1a9e:	4699                	li	a3,6
    1aa0:	bd69                	j	193a <stpncpy+0xb2>
    1aa2:	8082                	ret
    1aa4:	8082                	ret
    1aa6:	8082                	ret

0000000000001aa8 <open>:
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
}

static inline long __syscall3(long n, long a, long b, long c)
{
    register long a7 __asm__("a7") = n;
    1aa8:	03800893          	li	a7,56
    register long a0 __asm__("a0") = a;
    register long a1 __asm__("a1") = b;
    register long a2 __asm__("a2") = c;
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1aac:	00000073          	ecall

#include "syscall.h"

int open(const char *path, int flags, int mode) {
    return syscall(SYS_openat, path, flags, mode);
}
    1ab0:	2501                	sext.w	a0,a0
    1ab2:	8082                	ret

0000000000001ab4 <close>:
    register long a7 __asm__("a7") = n;
    1ab4:	03900893          	li	a7,57
    __asm_syscall("r"(a7), "0"(a0))
    1ab8:	00000073          	ecall

int close(int fd) {
    return syscall(SYS_close, fd);
}
    1abc:	2501                	sext.w	a0,a0
    1abe:	8082                	ret

0000000000001ac0 <read>:
    register long a7 __asm__("a7") = n;
    1ac0:	03f00893          	li	a7,63
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1ac4:	00000073          	ecall

ssize_t read(int fd, void *buf, unsigned long long len) {
    return syscall(SYS_read, fd, buf, len);
}
    1ac8:	8082                	ret

0000000000001aca <write>:
    register long a7 __asm__("a7") = n;
    1aca:	04000893          	li	a7,64
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1ace:	00000073          	ecall

ssize_t write(int fd, const void *buf, unsigned long long len) {
    return syscall(SYS_write, fd, buf, len);
}
    1ad2:	8082                	ret

0000000000001ad4 <getpid>:
    register long a7 __asm__("a7") = n;
    1ad4:	0ac00893          	li	a7,172
    __asm_syscall("r"(a7))
    1ad8:	00000073          	ecall

int getpid(void) {
    return syscall(SYS_getpid);
}
    1adc:	2501                	sext.w	a0,a0
    1ade:	8082                	ret

0000000000001ae0 <sched_yield>:
    register long a7 __asm__("a7") = n;
    1ae0:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1ae4:	00000073          	ecall

int sched_yield(void) {
    return syscall(SYS_sched_yield);
}
    1ae8:	2501                	sext.w	a0,a0
    1aea:	8082                	ret

0000000000001aec <fork>:
    register long a7 __asm__("a7") = n;
    1aec:	0dc00893          	li	a7,220
    __asm_syscall("r"(a7))
    1af0:	00000073          	ecall

int fork(void) {
    return syscall(SYS_clone);
}
    1af4:	2501                	sext.w	a0,a0
    1af6:	8082                	ret

0000000000001af8 <exit>:
    register long a7 __asm__("a7") = n;
    1af8:	05d00893          	li	a7,93
    __asm_syscall("r"(a7), "0"(a0))
    1afc:	00000073          	ecall

void exit(int code) {
    syscall(SYS_exit, code);
}
    1b00:	8082                	ret

0000000000001b02 <wait>:
    register long a7 __asm__("a7") = n;
    1b02:	10400893          	li	a7,260
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
    1b06:	00000073          	ecall

int wait(int pid, int* code) {
    return syscall(SYS_wait4, pid, code);
}
    1b0a:	2501                	sext.w	a0,a0
    1b0c:	8082                	ret

0000000000001b0e <exec>:
    register long a7 __asm__("a7") = n;
    1b0e:	0dd00893          	li	a7,221
    __asm_syscall("r"(a7), "0"(a0))
    1b12:	00000073          	ecall

int exec(char* name) {
    return syscall(SYS_execve, name);
}
    1b16:	2501                	sext.w	a0,a0
    1b18:	8082                	ret

0000000000001b1a <get_time>:
    register long a7 __asm__("a7") = n;
    1b1a:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1b1e:	00000073          	ecall

uint64 get_time() {
    return syscall(SYS_times);
}
    1b22:	8082                	ret

0000000000001b24 <sleep>:

int sleep(unsigned long long time) {
    1b24:	872a                	mv	a4,a0
    register long a7 __asm__("a7") = n;
    1b26:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1b2a:	00000073          	ecall
    1b2e:	87aa                	mv	a5,a0
    1b30:	00000073          	ecall
    unsigned long long s = get_time();
    while(get_time() < s + time) {
    1b34:	97ba                	add	a5,a5,a4
    1b36:	00f57c63          	bgeu	a0,a5,1b4e <sleep+0x2a>
    register long a7 __asm__("a7") = n;
    1b3a:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1b3e:	00000073          	ecall
    register long a7 __asm__("a7") = n;
    1b42:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1b46:	00000073          	ecall
    1b4a:	fef568e3          	bltu	a0,a5,1b3a <sleep+0x16>
        sched_yield();
    }
    return 0;
}
    1b4e:	4501                	li	a0,0
    1b50:	8082                	ret

0000000000001b52 <pipe>:
    register long a7 __asm__("a7") = n;
    1b52:	03b00893          	li	a7,59
    __asm_syscall("r"(a7), "0"(a0))
    1b56:	00000073          	ecall

int pipe(void* p) {
    return syscall(SYS_pipe2, p);
    1b5a:	2501                	sext.w	a0,a0
    1b5c:	8082                	ret

Disassembly of section .text.startup:

0000000000001b5e <main>:

int main() {
    1b5e:	7159                	addi	sp,sp,-112
    printf("C user shell\n");
    1b60:	00000517          	auipc	a0,0x0
    1b64:	16050513          	addi	a0,a0,352 # 1cc0 <main+0x162>
int main() {
    1b68:	f486                	sd	ra,104(sp)
    1b6a:	eca6                	sd	s1,88(sp)
    1b6c:	e8ca                	sd	s2,80(sp)
    1b6e:	e4ce                	sd	s3,72(sp)
    1b70:	e0d2                	sd	s4,64(sp)
    1b72:	fc56                	sd	s5,56(sp)
    1b74:	f85a                	sd	s6,48(sp)
    1b76:	f45e                	sd	s7,40(sp)
    1b78:	f062                	sd	s8,32(sp)
    1b7a:	ec66                	sd	s9,24(sp)
    1b7c:	e86a                	sd	s10,16(sp)
    1b7e:	f0a2                	sd	s0,96(sp)
    printf("C user shell\n");
    1b80:	d68ff0ef          	jal	ra,10e8 <printf>
    printf(">> ");
    1b84:	00000517          	auipc	a0,0x0
    1b88:	14c50513          	addi	a0,a0,332 # 1cd0 <main+0x172>
    1b8c:	00000997          	auipc	s3,0x0
    1b90:	1f498993          	addi	s3,s3,500 # 1d80 <line>
    1b94:	d54ff0ef          	jal	ra,10e8 <printf>
    1b98:	00000917          	auipc	s2,0x0
    1b9c:	25090913          	addi	s2,s2,592 # 1de8 <top>
    while (1) {
        char c = getchar();
        switch (c) {
    1ba0:	44b5                	li	s1,13
            case LF:
            case CR:
                printf("\n");
    1ba2:	00000a97          	auipc	s5,0x0
    1ba6:	136a8a93          	addi	s5,s5,310 # 1cd8 <main+0x17a>
                        assert(pid == exit_pid, -1);
                        printf("Shell: Process %d exited with code %d\n", pid, xstate);
                    }
                    clear();
                }
                printf(">> ");
    1baa:	00000a17          	auipc	s4,0x0
    1bae:	126a0a13          	addi	s4,s4,294 # 1cd0 <main+0x172>
                        printf("Shell: Process %d exited with code %d\n", pid, xstate);
    1bb2:	00000c97          	auipc	s9,0x0
    1bb6:	156c8c93          	addi	s9,s9,342 # 1d08 <main+0x1aa>
                        if (exec(line) < 0) {
    1bba:	8c4e                	mv	s8,s3
                        panic("unreachable!");
    1bbc:	00000b97          	auipc	s7,0x0
    1bc0:	13cb8b93          	addi	s7,s7,316 # 1cf8 <main+0x19a>
                            printf("no such program\n");
    1bc4:	00000d17          	auipc	s10,0x0
    1bc8:	11cd0d13          	addi	s10,s10,284 # 1ce0 <main+0x182>
                break;
            case BS:
            case DL:
                if (!is_empty()) {
                    putchar(BS);
                    printf(" ");
    1bcc:	00000b17          	auipc	s6,0x0
    1bd0:	164b0b13          	addi	s6,s6,356 # 1d30 <main+0x1d2>
        char c = getchar();
    1bd4:	c8eff0ef          	jal	ra,1062 <getchar>
    1bd8:	842a                	mv	s0,a0
        switch (c) {
    1bda:	0ff57513          	andi	a0,a0,255
    1bde:	00950a63          	beq	a0,s1,1bf2 <main+0x94>
    1be2:	02a4ca63          	blt	s1,a0,1c16 <main+0xb8>
    1be6:	47a1                	li	a5,8
    1be8:	04f50763          	beq	a0,a5,1c36 <main+0xd8>
    1bec:	47a9                	li	a5,10
    1bee:	02f51863          	bne	a0,a5,1c1e <main+0xc0>
                printf("\n");
    1bf2:	8556                	mv	a0,s5
    1bf4:	cf4ff0ef          	jal	ra,10e8 <printf>
    return top == 0;
    1bf8:	00092783          	lw	a5,0(s2)
                if (!is_empty()) {
    1bfc:	efb9                	bnez	a5,1c5a <main+0xfc>
                printf(">> ");
    1bfe:	8552                	mv	a0,s4
    1c00:	ce8ff0ef          	jal	ra,10e8 <printf>
        char c = getchar();
    1c04:	c5eff0ef          	jal	ra,1062 <getchar>
    1c08:	842a                	mv	s0,a0
        switch (c) {
    1c0a:	0ff57513          	andi	a0,a0,255
    1c0e:	fe9502e3          	beq	a0,s1,1bf2 <main+0x94>
    1c12:	fca4dae3          	bge	s1,a0,1be6 <main+0x88>
    1c16:	07f00793          	li	a5,127
    1c1a:	00f50e63          	beq	a0,a5,1c36 <main+0xd8>
                    putchar(BS);
                    pop();
                }
                break;
            default:
                putchar(c);
    1c1e:	c62ff0ef          	jal	ra,1080 <putchar>
    line[top++] = c;
    1c22:	00092783          	lw	a5,0(s2)
    1c26:	0017871b          	addiw	a4,a5,1
    1c2a:	97ce                	add	a5,a5,s3
    1c2c:	00e92023          	sw	a4,0(s2)
        char c = getchar();
    1c30:	00878023          	sb	s0,0(a5)
}
    1c34:	b745                	j	1bd4 <main+0x76>
                if (!is_empty()) {
    1c36:	00092783          	lw	a5,0(s2)
    1c3a:	dfc9                	beqz	a5,1bd4 <main+0x76>
                    putchar(BS);
    1c3c:	4521                	li	a0,8
    1c3e:	c42ff0ef          	jal	ra,1080 <putchar>
                    printf(" ");
    1c42:	855a                	mv	a0,s6
    1c44:	ca4ff0ef          	jal	ra,10e8 <printf>
                    putchar(BS);
    1c48:	4521                	li	a0,8
    1c4a:	c36ff0ef          	jal	ra,1080 <putchar>
    --top;
    1c4e:	00092783          	lw	a5,0(s2)
    1c52:	37fd                	addiw	a5,a5,-1
    1c54:	00f92023          	sw	a5,0(s2)
}
    1c58:	bfb5                	j	1bd4 <main+0x76>
    line[top++] = c;
    1c5a:	0017871b          	addiw	a4,a5,1
    1c5e:	97ce                	add	a5,a5,s3
    1c60:	00e92023          	sw	a4,0(s2)
    1c64:	00078023          	sb	zero,0(a5)
                    int pid = fork();
    1c68:	e85ff0ef          	jal	ra,1aec <fork>
    1c6c:	842a                	mv	s0,a0
                    if (pid == 0) {
    1c6e:	ed11                	bnez	a0,1c8a <main+0x12c>
                        if (exec(line) < 0) {
    1c70:	8562                	mv	a0,s8
    1c72:	e9dff0ef          	jal	ra,1b0e <exec>
    1c76:	02054b63          	bltz	a0,1cac <main+0x14e>
                        panic("unreachable!");
    1c7a:	855e                	mv	a0,s7
    1c7c:	f9cff0ef          	jal	ra,1418 <panic>
    top = 0;
    1c80:	00000797          	auipc	a5,0x0
    1c84:	1607a423          	sw	zero,360(a5) # 1de8 <top>
}
    1c88:	bf9d                	j	1bfe <main+0xa0>
                        exit_pid = wait(pid, &xstate);
    1c8a:	006c                	addi	a1,sp,12
                        int xstate = 0;
    1c8c:	c602                	sw	zero,12(sp)
                        exit_pid = wait(pid, &xstate);
    1c8e:	e75ff0ef          	jal	ra,1b02 <wait>
                        assert(pid == exit_pid, -1);
    1c92:	40a40533          	sub	a0,s0,a0
    1c96:	55fd                	li	a1,-1
    1c98:	00153513          	seqz	a0,a0
    1c9c:	f90ff0ef          	jal	ra,142c <assert>
                        printf("Shell: Process %d exited with code %d\n", pid, xstate);
    1ca0:	4632                	lw	a2,12(sp)
    1ca2:	85a2                	mv	a1,s0
    1ca4:	8566                	mv	a0,s9
    1ca6:	c42ff0ef          	jal	ra,10e8 <printf>
    1caa:	bfd9                	j	1c80 <main+0x122>
                            printf("no such program\n");
    1cac:	856a                	mv	a0,s10
    1cae:	c3aff0ef          	jal	ra,10e8 <printf>
                            exit(0);
    1cb2:	4501                	li	a0,0
    1cb4:	e45ff0ef          	jal	ra,1af8 <exit>
    1cb8:	b7c9                	j	1c7a <main+0x11c>
