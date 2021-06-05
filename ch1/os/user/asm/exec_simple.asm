
/home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/exec_simple:     file format elf64-littleriscv


Disassembly of section .startup:

0000000000001000 <_start>:
.text
.globl _start
_start:
    mv a0, sp
    1000:	850a                	mv	a0,sp
    tail __start_main
    1002:	0040006f          	j	1006 <__start_main>

Disassembly of section .text:

0000000000001006 <__start_main>:
#include <unistd.h>

extern int main();

int __start_main(long* p)
{
    1006:	1141                	addi	sp,sp,-16
    1008:	e406                	sd	ra,8(sp)
    exit(main());
    100a:	2c1000ef          	jal	ra,1aca <main>
    100e:	257000ef          	jal	ra,1a64 <exit>
    return 0;
}
    1012:	60a2                	ld	ra,8(sp)
    1014:	4501                	li	a0,0
    1016:	0141                	addi	sp,sp,16
    1018:	8082                	ret

000000000000101a <getchar>:
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int getchar() {
    101a:	1101                	addi	sp,sp,-32
    char byte = 0;
    read(stdin, &byte, 1);
    101c:	00f10593          	addi	a1,sp,15
    1020:	4605                	li	a2,1
    1022:	4501                	li	a0,0
int getchar() {
    1024:	ec06                	sd	ra,24(sp)
    char byte = 0;
    1026:	000107a3          	sb	zero,15(sp)
    read(stdin, &byte, 1);
    102a:	203000ef          	jal	ra,1a2c <read>
    return byte;
}
    102e:	60e2                	ld	ra,24(sp)
    1030:	00f14503          	lbu	a0,15(sp)
    1034:	6105                	addi	sp,sp,32
    1036:	8082                	ret

0000000000001038 <putchar>:

int putchar(int c)
{
    1038:	1141                	addi	sp,sp,-16
    103a:	e406                	sd	ra,8(sp)
    103c:	87aa                	mv	a5,a0
    static char put[2] = {0, 0};
    put[0] = c;
    103e:	00001597          	auipc	a1,0x1
    1042:	b0258593          	addi	a1,a1,-1278 # 1b40 <put.1058>
    return write(stdout, put, 1);
    1046:	4605                	li	a2,1
    1048:	4501                	li	a0,0
    put[0] = c;
    104a:	00f58023          	sb	a5,0(a1)
    return write(stdout, put, 1);
    104e:	1e9000ef          	jal	ra,1a36 <write>
}
    1052:	60a2                	ld	ra,8(sp)
    1054:	2501                	sext.w	a0,a0
    1056:	0141                	addi	sp,sp,16
    1058:	8082                	ret

000000000000105a <puts>:

int puts(const char* s)
{
    105a:	1141                	addi	sp,sp,-16
    105c:	e022                	sd	s0,0(sp)
    105e:	e406                	sd	ra,8(sp)
    1060:	842a                	mv	s0,a0
    int r;
    r = -(write(stdout, s, strlen(s)) < 0 || putchar('\n') < 0);
    1062:	60c000ef          	jal	ra,166e <strlen>
    1066:	862a                	mv	a2,a0
    1068:	85a2                	mv	a1,s0
    106a:	4501                	li	a0,0
    106c:	1cb000ef          	jal	ra,1a36 <write>
    1070:	00055763          	bgez	a0,107e <puts+0x24>
    return r;
}
    1074:	60a2                	ld	ra,8(sp)
    1076:	6402                	ld	s0,0(sp)
    1078:	557d                	li	a0,-1
    107a:	0141                	addi	sp,sp,16
    107c:	8082                	ret
    put[0] = c;
    107e:	00001597          	auipc	a1,0x1
    1082:	ac258593          	addi	a1,a1,-1342 # 1b40 <put.1058>
    1086:	47a9                	li	a5,10
    return write(stdout, put, 1);
    1088:	4605                	li	a2,1
    108a:	4501                	li	a0,0
    put[0] = c;
    108c:	00f58023          	sb	a5,0(a1)
    return write(stdout, put, 1);
    1090:	1a7000ef          	jal	ra,1a36 <write>
}
    1094:	60a2                	ld	ra,8(sp)
    1096:	6402                	ld	s0,0(sp)
    1098:	41f5551b          	sraiw	a0,a0,0x1f
    109c:	0141                	addi	sp,sp,16
    109e:	8082                	ret

00000000000010a0 <printf>:
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
        putchar(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(const char* fmt, ...) {
    10a0:	7131                	addi	sp,sp,-192
    10a2:	fc86                	sd	ra,120(sp)
    10a4:	f8a2                	sd	s0,112(sp)
    10a6:	f4a6                	sd	s1,104(sp)
    10a8:	f0ca                	sd	s2,96(sp)
    10aa:	ecce                	sd	s3,88(sp)
    10ac:	e8d2                	sd	s4,80(sp)
    10ae:	e4d6                	sd	s5,72(sp)
    10b0:	e0da                	sd	s6,64(sp)
    10b2:	fc5e                	sd	s7,56(sp)
    10b4:	f862                	sd	s8,48(sp)
    10b6:	f466                	sd	s9,40(sp)
    10b8:	f06a                	sd	s10,32(sp)
    va_list ap;
    int i, c;
    char *s;

    va_start(ap, fmt);
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    10ba:	00054303          	lbu	t1,0(a0)
void printf(const char* fmt, ...) {
    10be:	f53e                	sd	a5,168(sp)
    va_start(ap, fmt);
    10c0:	013c                	addi	a5,sp,136
void printf(const char* fmt, ...) {
    10c2:	e52e                	sd	a1,136(sp)
    10c4:	e932                	sd	a2,144(sp)
    10c6:	ed36                	sd	a3,152(sp)
    10c8:	f13a                	sd	a4,160(sp)
    10ca:	f942                	sd	a6,176(sp)
    10cc:	fd46                	sd	a7,184(sp)
    va_start(ap, fmt);
    10ce:	e43e                	sd	a5,8(sp)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    10d0:	0e030663          	beqz	t1,11bc <printf+0x11c>
    10d4:	8a2a                	mv	s4,a0
    10d6:	0003071b          	sext.w	a4,t1
    10da:	4901                	li	s2,0
        if (c != '%') {
    10dc:	02500a93          	li	s5,37
            continue;
        }
        c = fmt[++i] & 0xff;
        if (c == 0)
            break;
        switch (c) {
    10e0:	07000b93          	li	s7,112
    put[0] = c;
    10e4:	00001417          	auipc	s0,0x1
    10e8:	a5c40413          	addi	s0,s0,-1444 # 1b40 <put.1058>
    10ec:	03000c93          	li	s9,48
    10f0:	07800c13          	li	s8,120
    10f4:	00001b17          	auipc	s6,0x1
    10f8:	a34b0b13          	addi	s6,s6,-1484 # 1b28 <digits>
        if (c != '%') {
    10fc:	0019079b          	addiw	a5,s2,1
    1100:	00fa09b3          	add	s3,s4,a5
    1104:	15571a63          	bne	a4,s5,1258 <printf+0x1b8>
        c = fmt[++i] & 0xff;
    1108:	0009c483          	lbu	s1,0(s3)
        if (c == 0)
    110c:	c8c5                	beqz	s1,11bc <printf+0x11c>
        switch (c) {
    110e:	2909                	addiw	s2,s2,2
    1110:	012a09b3          	add	s3,s4,s2
    1114:	19748c63          	beq	s1,s7,12ac <printf+0x20c>
    1118:	0c9be063          	bltu	s7,s1,11d8 <printf+0x138>
    111c:	23548663          	beq	s1,s5,1348 <printf+0x2a8>
    1120:	06400793          	li	a5,100
    1124:	1ef49563          	bne	s1,a5,130e <printf+0x26e>
            case 'd':
                printint(va_arg(ap, int), 10, 1);
    1128:	67a2                	ld	a5,8(sp)
    112a:	4394                	lw	a3,0(a5)
    112c:	07a1                	addi	a5,a5,8
    112e:	e43e                	sd	a5,8(sp)
    1130:	0ff6f793          	andi	a5,a3,255
    if (sign && (sign = xx < 0))
    1134:	0006d663          	bgez	a3,1140 <printf+0xa0>
        x = -xx;
    1138:	40f007bb          	negw	a5,a5
    113c:	0ff7f793          	andi	a5,a5,255
        buf[i++] = digits[x % base];
    1140:	4729                	li	a4,10
    1142:	02e7e63b          	remw	a2,a5,a4
    } while ((x /= base) != 0);
    1146:	02e7c4bb          	divw	s1,a5,a4
        buf[i++] = digits[x % base];
    114a:	965a                	add	a2,a2,s6
    114c:	00064603          	lbu	a2,0(a2)
    1150:	00c10823          	sb	a2,16(sp)
    } while ((x /= base) != 0);
    1154:	24048263          	beqz	s1,1398 <printf+0x2f8>
        buf[i++] = digits[x % base];
    1158:	02e4e63b          	remw	a2,s1,a4
    } while ((x /= base) != 0);
    115c:	02e4c7bb          	divw	a5,s1,a4
        buf[i++] = digits[x % base];
    1160:	00cb0733          	add	a4,s6,a2
    1164:	00074703          	lbu	a4,0(a4)
    1168:	00e108a3          	sb	a4,17(sp)
    } while ((x /= base) != 0);
    116c:	22078863          	beqz	a5,139c <printf+0x2fc>
        buf[i++] = digits[x % base];
    1170:	97da                	add	a5,a5,s6
    1172:	0007c703          	lbu	a4,0(a5)
    1176:	4489                	li	s1,2
    1178:	478d                	li	a5,3
    117a:	00e10923          	sb	a4,18(sp)
    if (sign)
    117e:	0006d963          	bgez	a3,1190 <printf+0xf0>
        buf[i++] = '-';
    1182:	1018                	addi	a4,sp,32
    1184:	973e                	add	a4,a4,a5
    1186:	02d00693          	li	a3,45
    118a:	fed70823          	sb	a3,-16(a4)
        buf[i++] = digits[x % base];
    118e:	84be                	mv	s1,a5
    while (--i >= 0)
    1190:	081c                	addi	a5,sp,16
    1192:	94be                	add	s1,s1,a5
    1194:	00f10d13          	addi	s10,sp,15
    put[0] = c;
    1198:	0004c783          	lbu	a5,0(s1)
    return write(stdout, put, 1);
    119c:	4605                	li	a2,1
    119e:	14fd                	addi	s1,s1,-1
    11a0:	85a2                	mv	a1,s0
    11a2:	4501                	li	a0,0
    put[0] = c;
    11a4:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    11a8:	08f000ef          	jal	ra,1a36 <write>
    while (--i >= 0)
    11ac:	ffa496e3          	bne	s1,s10,1198 <printf+0xf8>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    11b0:	0009c303          	lbu	t1,0(s3)
    11b4:	0003071b          	sext.w	a4,t1
    11b8:	f40312e3          	bnez	t1,10fc <printf+0x5c>
                putchar(c);
                break;
        }
    }
    va_end(ap);
    11bc:	70e6                	ld	ra,120(sp)
    11be:	7446                	ld	s0,112(sp)
    11c0:	74a6                	ld	s1,104(sp)
    11c2:	7906                	ld	s2,96(sp)
    11c4:	69e6                	ld	s3,88(sp)
    11c6:	6a46                	ld	s4,80(sp)
    11c8:	6aa6                	ld	s5,72(sp)
    11ca:	6b06                	ld	s6,64(sp)
    11cc:	7be2                	ld	s7,56(sp)
    11ce:	7c42                	ld	s8,48(sp)
    11d0:	7ca2                	ld	s9,40(sp)
    11d2:	7d02                	ld	s10,32(sp)
    11d4:	6129                	addi	sp,sp,192
    11d6:	8082                	ret
        switch (c) {
    11d8:	07300793          	li	a5,115
    11dc:	0af48063          	beq	s1,a5,127c <printf+0x1dc>
    11e0:	07800793          	li	a5,120
    11e4:	12f49563          	bne	s1,a5,130e <printf+0x26e>
                printint(va_arg(ap, int), 16, 1);
    11e8:	67a2                	ld	a5,8(sp)
    11ea:	4398                	lw	a4,0(a5)
    11ec:	07a1                	addi	a5,a5,8
    11ee:	e43e                	sd	a5,8(sp)
    11f0:	0ff77793          	andi	a5,a4,255
    if (sign && (sign = xx < 0))
    11f4:	16074b63          	bltz	a4,136a <printf+0x2ca>
        buf[i++] = digits[x % base];
    11f8:	8bbd                	andi	a5,a5,15
    11fa:	97da                	add	a5,a5,s6
    11fc:	0007c783          	lbu	a5,0(a5)
    } while ((x /= base) != 0);
    1200:	4047549b          	sraiw	s1,a4,0x4
    1204:	88bd                	andi	s1,s1,15
        buf[i++] = digits[x % base];
    1206:	00f10823          	sb	a5,16(sp)
    } while ((x /= base) != 0);
    120a:	c085                	beqz	s1,122a <printf+0x18a>
        buf[i++] = digits[x % base];
    120c:	94da                	add	s1,s1,s6
    120e:	0004c783          	lbu	a5,0(s1)
    1212:	4485                	li	s1,1
    1214:	00f108a3          	sb	a5,17(sp)
    if (sign)
    1218:	00075963          	bgez	a4,122a <printf+0x18a>
        buf[i++] = digits[x % base];
    121c:	4489                	li	s1,2
        buf[i++] = '-';
    121e:	101c                	addi	a5,sp,32
    1220:	02d00713          	li	a4,45
    1224:	97a6                	add	a5,a5,s1
    1226:	fee78823          	sb	a4,-16(a5)
    while (--i >= 0)
    122a:	081c                	addi	a5,sp,16
    122c:	94be                	add	s1,s1,a5
    122e:	00f10d13          	addi	s10,sp,15
    put[0] = c;
    1232:	0004c783          	lbu	a5,0(s1)
    return write(stdout, put, 1);
    1236:	4605                	li	a2,1
    1238:	14fd                	addi	s1,s1,-1
    123a:	85a2                	mv	a1,s0
    123c:	4501                	li	a0,0
    put[0] = c;
    123e:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    1242:	7f4000ef          	jal	ra,1a36 <write>
    while (--i >= 0)
    1246:	ffa496e3          	bne	s1,s10,1232 <printf+0x192>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    124a:	0009c303          	lbu	t1,0(s3)
    124e:	0003071b          	sext.w	a4,t1
    1252:	ea0315e3          	bnez	t1,10fc <printf+0x5c>
    1256:	b79d                	j	11bc <printf+0x11c>
    return write(stdout, put, 1);
    1258:	4605                	li	a2,1
    125a:	00001597          	auipc	a1,0x1
    125e:	8e658593          	addi	a1,a1,-1818 # 1b40 <put.1058>
    1262:	4501                	li	a0,0
    put[0] = c;
    1264:	00640023          	sb	t1,0(s0)
            continue;
    1268:	893e                	mv	s2,a5
    return write(stdout, put, 1);
    126a:	7cc000ef          	jal	ra,1a36 <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    126e:	0009c303          	lbu	t1,0(s3)
    1272:	0003071b          	sext.w	a4,t1
    1276:	e80313e3          	bnez	t1,10fc <printf+0x5c>
    127a:	b789                	j	11bc <printf+0x11c>
                if ((s = va_arg(ap, char *)) == 0)
    127c:	67a2                	ld	a5,8(sp)
    127e:	6384                	ld	s1,0(a5)
    1280:	07a1                	addi	a5,a5,8
    1282:	e43e                	sd	a5,8(sp)
    1284:	e891                	bnez	s1,1298 <printf+0x1f8>
    1286:	a211                	j	138a <printf+0x2ea>
    return write(stdout, put, 1);
    1288:	4605                	li	a2,1
    128a:	85a2                	mv	a1,s0
    128c:	4501                	li	a0,0
                for (; *s; s++)
    128e:	0485                	addi	s1,s1,1
    put[0] = c;
    1290:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    1294:	7a2000ef          	jal	ra,1a36 <write>
                for (; *s; s++)
    1298:	0004c783          	lbu	a5,0(s1)
    129c:	f7f5                	bnez	a5,1288 <printf+0x1e8>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    129e:	0009c303          	lbu	t1,0(s3)
    12a2:	0003071b          	sext.w	a4,t1
    12a6:	e4031be3          	bnez	t1,10fc <printf+0x5c>
    12aa:	bf09                	j	11bc <printf+0x11c>
                printptr(va_arg(ap, uint64));
    12ac:	67a2                	ld	a5,8(sp)
    return write(stdout, put, 1);
    12ae:	4605                	li	a2,1
    12b0:	00001597          	auipc	a1,0x1
    12b4:	89058593          	addi	a1,a1,-1904 # 1b40 <put.1058>
                printptr(va_arg(ap, uint64));
    12b8:	00878713          	addi	a4,a5,8
    return write(stdout, put, 1);
    12bc:	4501                	li	a0,0
                printptr(va_arg(ap, uint64));
    12be:	0007bd03          	ld	s10,0(a5)
    12c2:	e43a                	sd	a4,8(sp)
    put[0] = c;
    12c4:	01940023          	sb	s9,0(s0)
    return write(stdout, put, 1);
    12c8:	76e000ef          	jal	ra,1a36 <write>
    12cc:	4605                	li	a2,1
    12ce:	00001597          	auipc	a1,0x1
    12d2:	87258593          	addi	a1,a1,-1934 # 1b40 <put.1058>
    12d6:	4501                	li	a0,0
    put[0] = c;
    12d8:	01840023          	sb	s8,0(s0)
    return write(stdout, put, 1);
    12dc:	44c1                	li	s1,16
    12de:	758000ef          	jal	ra,1a36 <write>
        putchar(digits[x >> (sizeof(uint64) * 8 - 4)]);
    12e2:	03cd5793          	srli	a5,s10,0x3c
    12e6:	97da                	add	a5,a5,s6
    put[0] = c;
    12e8:	0007c783          	lbu	a5,0(a5)
    12ec:	34fd                	addiw	s1,s1,-1
    return write(stdout, put, 1);
    12ee:	4605                	li	a2,1
    12f0:	85a2                	mv	a1,s0
    12f2:	4501                	li	a0,0
    put[0] = c;
    12f4:	00f40023          	sb	a5,0(s0)
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    12f8:	0d12                	slli	s10,s10,0x4
    return write(stdout, put, 1);
    12fa:	73c000ef          	jal	ra,1a36 <write>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    12fe:	f0f5                	bnez	s1,12e2 <printf+0x242>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1300:	0009c303          	lbu	t1,0(s3)
    1304:	0003071b          	sext.w	a4,t1
    1308:	de031ae3          	bnez	t1,10fc <printf+0x5c>
    130c:	bd45                	j	11bc <printf+0x11c>
    put[0] = c;
    130e:	02500793          	li	a5,37
    return write(stdout, put, 1);
    1312:	4605                	li	a2,1
    1314:	00001597          	auipc	a1,0x1
    1318:	82c58593          	addi	a1,a1,-2004 # 1b40 <put.1058>
    131c:	4501                	li	a0,0
    put[0] = c;
    131e:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    1322:	714000ef          	jal	ra,1a36 <write>
    1326:	4605                	li	a2,1
    1328:	00001597          	auipc	a1,0x1
    132c:	81858593          	addi	a1,a1,-2024 # 1b40 <put.1058>
    1330:	4501                	li	a0,0
    put[0] = c;
    1332:	00940023          	sb	s1,0(s0)
    return write(stdout, put, 1);
    1336:	700000ef          	jal	ra,1a36 <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    133a:	0009c303          	lbu	t1,0(s3)
    133e:	0003071b          	sext.w	a4,t1
    1342:	da031de3          	bnez	t1,10fc <printf+0x5c>
    1346:	bd9d                	j	11bc <printf+0x11c>
    return write(stdout, put, 1);
    1348:	4605                	li	a2,1
    134a:	00000597          	auipc	a1,0x0
    134e:	7f658593          	addi	a1,a1,2038 # 1b40 <put.1058>
    1352:	4501                	li	a0,0
    put[0] = c;
    1354:	01540023          	sb	s5,0(s0)
    return write(stdout, put, 1);
    1358:	6de000ef          	jal	ra,1a36 <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    135c:	0009c303          	lbu	t1,0(s3)
    1360:	0003071b          	sext.w	a4,t1
    1364:	d8031ce3          	bnez	t1,10fc <printf+0x5c>
    1368:	bd91                	j	11bc <printf+0x11c>
        x = -xx;
    136a:	40f007bb          	negw	a5,a5
        buf[i++] = digits[x % base];
    136e:	00f7f693          	andi	a3,a5,15
    1372:	96da                	add	a3,a3,s6
    1374:	0006c683          	lbu	a3,0(a3)
        x = -xx;
    1378:	0ff7f493          	andi	s1,a5,255
    } while ((x /= base) != 0);
    137c:	8091                	srli	s1,s1,0x4
        buf[i++] = digits[x % base];
    137e:	00d10823          	sb	a3,16(sp)
    } while ((x /= base) != 0);
    1382:	e80495e3          	bnez	s1,120c <printf+0x16c>
        buf[i++] = digits[x % base];
    1386:	4485                	li	s1,1
    1388:	bd59                	j	121e <printf+0x17e>
                s = "(null)";
    138a:	00000497          	auipc	s1,0x0
    138e:	77e48493          	addi	s1,s1,1918 # 1b08 <main+0x3e>
                for (; *s; s++)
    1392:	02800793          	li	a5,40
    1396:	bdcd                	j	1288 <printf+0x1e8>
        buf[i++] = digits[x % base];
    1398:	4785                	li	a5,1
    139a:	b3d5                	j	117e <printf+0xde>
    139c:	4789                	li	a5,2
    139e:	4485                	li	s1,1
    13a0:	bbf9                	j	117e <printf+0xde>

00000000000013a2 <isspace>:
#define HIGHS      (ONES * (UCHAR_MAX / 2 + 1))
#define HASZERO(x) (((x)-ONES) & ~(x) & HIGHS)

int isspace(int c)
{
    return c == ' ' || (unsigned)c - '\t' < 5;
    13a2:	02000793          	li	a5,32
    13a6:	00f50663          	beq	a0,a5,13b2 <isspace+0x10>
    13aa:	355d                	addiw	a0,a0,-9
    13ac:	00553513          	sltiu	a0,a0,5
    13b0:	8082                	ret
    13b2:	4505                	li	a0,1
}
    13b4:	8082                	ret

00000000000013b6 <isdigit>:

int isdigit(int c)
{
    return (unsigned)c - '0' < 10;
    13b6:	fd05051b          	addiw	a0,a0,-48
}
    13ba:	00a53513          	sltiu	a0,a0,10
    13be:	8082                	ret

00000000000013c0 <atoi>:
    return c == ' ' || (unsigned)c - '\t' < 5;
    13c0:	02000613          	li	a2,32
    13c4:	4591                	li	a1,4

int atoi(const char* s)
{
    int n = 0, neg = 0;
    while (isspace(*s))
    13c6:	00054703          	lbu	a4,0(a0)
    return c == ' ' || (unsigned)c - '\t' < 5;
    13ca:	ff77069b          	addiw	a3,a4,-9
    13ce:	04c70d63          	beq	a4,a2,1428 <atoi+0x68>
    13d2:	0007079b          	sext.w	a5,a4
    13d6:	04d5f963          	bgeu	a1,a3,1428 <atoi+0x68>
        s++;
    switch (*s) {
    13da:	02b00693          	li	a3,43
    13de:	04d70a63          	beq	a4,a3,1432 <atoi+0x72>
    13e2:	02d00693          	li	a3,45
    13e6:	06d70463          	beq	a4,a3,144e <atoi+0x8e>
        neg = 1;
    case '+':
        s++;
    }
    /* Compute n as a negative number to avoid overflow on INT_MIN */
    while (isdigit(*s))
    13ea:	fd07859b          	addiw	a1,a5,-48
    13ee:	4625                	li	a2,9
    13f0:	873e                	mv	a4,a5
    13f2:	86aa                	mv	a3,a0
    int n = 0, neg = 0;
    13f4:	4e01                	li	t3,0
    while (isdigit(*s))
    13f6:	04b66a63          	bltu	a2,a1,144a <atoi+0x8a>
    int n = 0, neg = 0;
    13fa:	4501                	li	a0,0
    while (isdigit(*s))
    13fc:	4825                	li	a6,9
    13fe:	0016c603          	lbu	a2,1(a3)
        n = 10 * n - (*s++ - '0');
    1402:	0025179b          	slliw	a5,a0,0x2
    1406:	9d3d                	addw	a0,a0,a5
    1408:	fd07031b          	addiw	t1,a4,-48
    140c:	0015189b          	slliw	a7,a0,0x1
    while (isdigit(*s))
    1410:	fd06059b          	addiw	a1,a2,-48
        n = 10 * n - (*s++ - '0');
    1414:	0685                	addi	a3,a3,1
    1416:	4068853b          	subw	a0,a7,t1
    while (isdigit(*s))
    141a:	0006071b          	sext.w	a4,a2
    141e:	feb870e3          	bgeu	a6,a1,13fe <atoi+0x3e>
    return neg ? n : -n;
    1422:	000e0563          	beqz	t3,142c <atoi+0x6c>
}
    1426:	8082                	ret
        s++;
    1428:	0505                	addi	a0,a0,1
    142a:	bf71                	j	13c6 <atoi+0x6>
    142c:	4113053b          	subw	a0,t1,a7
    1430:	8082                	ret
    while (isdigit(*s))
    1432:	00154783          	lbu	a5,1(a0)
    1436:	4625                	li	a2,9
        s++;
    1438:	00150693          	addi	a3,a0,1
    while (isdigit(*s))
    143c:	fd07859b          	addiw	a1,a5,-48
    1440:	0007871b          	sext.w	a4,a5
    int n = 0, neg = 0;
    1444:	4e01                	li	t3,0
    while (isdigit(*s))
    1446:	fab67ae3          	bgeu	a2,a1,13fa <atoi+0x3a>
    144a:	4501                	li	a0,0
}
    144c:	8082                	ret
    while (isdigit(*s))
    144e:	00154783          	lbu	a5,1(a0)
    1452:	4625                	li	a2,9
        s++;
    1454:	00150693          	addi	a3,a0,1
    while (isdigit(*s))
    1458:	fd07859b          	addiw	a1,a5,-48
    145c:	0007871b          	sext.w	a4,a5
    1460:	feb665e3          	bltu	a2,a1,144a <atoi+0x8a>
        neg = 1;
    1464:	4e05                	li	t3,1
    1466:	bf51                	j	13fa <atoi+0x3a>

0000000000001468 <memset>:

void* memset(void* dest, int c, size_t n)
{
    char* p = dest;
    for(int i = 0; i < n; ++i, *(p++) = c);
    1468:	16060d63          	beqz	a2,15e2 <memset+0x17a>
    146c:	40a007b3          	neg	a5,a0
    1470:	8b9d                	andi	a5,a5,7
    1472:	00778713          	addi	a4,a5,7
    1476:	482d                	li	a6,11
    1478:	0ff5f593          	andi	a1,a1,255
    147c:	fff60693          	addi	a3,a2,-1
    1480:	17076263          	bltu	a4,a6,15e4 <memset+0x17c>
    1484:	16e6ea63          	bltu	a3,a4,15f8 <memset+0x190>
    1488:	16078563          	beqz	a5,15f2 <memset+0x18a>
    148c:	00b50023          	sb	a1,0(a0)
    1490:	4705                	li	a4,1
    1492:	00150e93          	addi	t4,a0,1
    1496:	14e78c63          	beq	a5,a4,15ee <memset+0x186>
    149a:	00b500a3          	sb	a1,1(a0)
    149e:	4709                	li	a4,2
    14a0:	00250e93          	addi	t4,a0,2
    14a4:	14e78d63          	beq	a5,a4,15fe <memset+0x196>
    14a8:	00b50123          	sb	a1,2(a0)
    14ac:	470d                	li	a4,3
    14ae:	00350e93          	addi	t4,a0,3
    14b2:	12e78b63          	beq	a5,a4,15e8 <memset+0x180>
    14b6:	00b501a3          	sb	a1,3(a0)
    14ba:	4711                	li	a4,4
    14bc:	00450e93          	addi	t4,a0,4
    14c0:	14e78163          	beq	a5,a4,1602 <memset+0x19a>
    14c4:	00b50223          	sb	a1,4(a0)
    14c8:	4715                	li	a4,5
    14ca:	00550e93          	addi	t4,a0,5
    14ce:	12e78c63          	beq	a5,a4,1606 <memset+0x19e>
    14d2:	00b502a3          	sb	a1,5(a0)
    14d6:	471d                	li	a4,7
    14d8:	00650e93          	addi	t4,a0,6
    14dc:	12e79763          	bne	a5,a4,160a <memset+0x1a2>
    14e0:	00750e93          	addi	t4,a0,7
    14e4:	00b50323          	sb	a1,6(a0)
    14e8:	4f1d                	li	t5,7
    14ea:	00859713          	slli	a4,a1,0x8
    14ee:	8f4d                	or	a4,a4,a1
    14f0:	01059e13          	slli	t3,a1,0x10
    14f4:	01c76e33          	or	t3,a4,t3
    14f8:	01859313          	slli	t1,a1,0x18
    14fc:	006e6333          	or	t1,t3,t1
    1500:	02059893          	slli	a7,a1,0x20
    1504:	011368b3          	or	a7,t1,a7
    1508:	02859813          	slli	a6,a1,0x28
    150c:	40f60333          	sub	t1,a2,a5
    1510:	0108e833          	or	a6,a7,a6
    1514:	03059693          	slli	a3,a1,0x30
    1518:	00d866b3          	or	a3,a6,a3
    151c:	03859713          	slli	a4,a1,0x38
    1520:	97aa                	add	a5,a5,a0
    1522:	ff837813          	andi	a6,t1,-8
    1526:	8f55                	or	a4,a4,a3
    1528:	00f806b3          	add	a3,a6,a5
    152c:	e398                	sd	a4,0(a5)
    152e:	07a1                	addi	a5,a5,8
    1530:	fed79ee3          	bne	a5,a3,152c <memset+0xc4>
    1534:	ff837693          	andi	a3,t1,-8
    1538:	00de87b3          	add	a5,t4,a3
    153c:	01e6873b          	addw	a4,a3,t5
    1540:	0ad30663          	beq	t1,a3,15ec <memset+0x184>
    1544:	00b78023          	sb	a1,0(a5)
    1548:	0017069b          	addiw	a3,a4,1
    154c:	08c6fb63          	bgeu	a3,a2,15e2 <memset+0x17a>
    1550:	00b780a3          	sb	a1,1(a5)
    1554:	0027069b          	addiw	a3,a4,2
    1558:	08c6f563          	bgeu	a3,a2,15e2 <memset+0x17a>
    155c:	00b78123          	sb	a1,2(a5)
    1560:	0037069b          	addiw	a3,a4,3
    1564:	06c6ff63          	bgeu	a3,a2,15e2 <memset+0x17a>
    1568:	00b781a3          	sb	a1,3(a5)
    156c:	0047069b          	addiw	a3,a4,4
    1570:	06c6f963          	bgeu	a3,a2,15e2 <memset+0x17a>
    1574:	00b78223          	sb	a1,4(a5)
    1578:	0057069b          	addiw	a3,a4,5
    157c:	06c6f363          	bgeu	a3,a2,15e2 <memset+0x17a>
    1580:	00b782a3          	sb	a1,5(a5)
    1584:	0067069b          	addiw	a3,a4,6
    1588:	04c6fd63          	bgeu	a3,a2,15e2 <memset+0x17a>
    158c:	00b78323          	sb	a1,6(a5)
    1590:	0077069b          	addiw	a3,a4,7
    1594:	04c6f763          	bgeu	a3,a2,15e2 <memset+0x17a>
    1598:	00b783a3          	sb	a1,7(a5)
    159c:	0087069b          	addiw	a3,a4,8
    15a0:	04c6f163          	bgeu	a3,a2,15e2 <memset+0x17a>
    15a4:	00b78423          	sb	a1,8(a5)
    15a8:	0097069b          	addiw	a3,a4,9
    15ac:	02c6fb63          	bgeu	a3,a2,15e2 <memset+0x17a>
    15b0:	00b784a3          	sb	a1,9(a5)
    15b4:	00a7069b          	addiw	a3,a4,10
    15b8:	02c6f563          	bgeu	a3,a2,15e2 <memset+0x17a>
    15bc:	00b78523          	sb	a1,10(a5)
    15c0:	00b7069b          	addiw	a3,a4,11
    15c4:	00c6ff63          	bgeu	a3,a2,15e2 <memset+0x17a>
    15c8:	00b785a3          	sb	a1,11(a5)
    15cc:	00c7069b          	addiw	a3,a4,12
    15d0:	00c6f963          	bgeu	a3,a2,15e2 <memset+0x17a>
    15d4:	00b78623          	sb	a1,12(a5)
    15d8:	2735                	addiw	a4,a4,13
    15da:	00c77463          	bgeu	a4,a2,15e2 <memset+0x17a>
    15de:	00b786a3          	sb	a1,13(a5)
    return dest;
}
    15e2:	8082                	ret
    15e4:	472d                	li	a4,11
    15e6:	bd79                	j	1484 <memset+0x1c>
    for(int i = 0; i < n; ++i, *(p++) = c);
    15e8:	4f0d                	li	t5,3
    15ea:	b701                	j	14ea <memset+0x82>
    15ec:	8082                	ret
    15ee:	4f05                	li	t5,1
    15f0:	bded                	j	14ea <memset+0x82>
    15f2:	8eaa                	mv	t4,a0
    15f4:	4f01                	li	t5,0
    15f6:	bdd5                	j	14ea <memset+0x82>
    15f8:	87aa                	mv	a5,a0
    15fa:	4701                	li	a4,0
    15fc:	b7a1                	j	1544 <memset+0xdc>
    15fe:	4f09                	li	t5,2
    1600:	b5ed                	j	14ea <memset+0x82>
    1602:	4f11                	li	t5,4
    1604:	b5dd                	j	14ea <memset+0x82>
    1606:	4f15                	li	t5,5
    1608:	b5cd                	j	14ea <memset+0x82>
    160a:	4f19                	li	t5,6
    160c:	bdf9                	j	14ea <memset+0x82>

000000000000160e <strcmp>:

int strcmp(const char* l, const char* r)
{
    for (; *l == *r && *l; l++, r++)
    160e:	00054783          	lbu	a5,0(a0)
    1612:	0005c703          	lbu	a4,0(a1)
    1616:	00e79863          	bne	a5,a4,1626 <strcmp+0x18>
    161a:	0505                	addi	a0,a0,1
    161c:	0585                	addi	a1,a1,1
    161e:	fbe5                	bnez	a5,160e <strcmp>
    1620:	4501                	li	a0,0
        ;
    return *(unsigned char*)l - *(unsigned char*)r;
}
    1622:	9d19                	subw	a0,a0,a4
    1624:	8082                	ret
    1626:	0007851b          	sext.w	a0,a5
    162a:	bfe5                	j	1622 <strcmp+0x14>

000000000000162c <strncmp>:

int strncmp(const char* _l, const char* _r, size_t n)
{
    const unsigned char *l = (void*)_l, *r = (void*)_r;
    if (!n--)
    162c:	ce05                	beqz	a2,1664 <strncmp+0x38>
        return 0;
    for (; *l && *r && n && *l == *r; l++, r++, n--)
    162e:	00054703          	lbu	a4,0(a0)
    1632:	0005c783          	lbu	a5,0(a1)
    1636:	cb0d                	beqz	a4,1668 <strncmp+0x3c>
    if (!n--)
    1638:	167d                	addi	a2,a2,-1
    163a:	00c506b3          	add	a3,a0,a2
    163e:	a819                	j	1654 <strncmp+0x28>
    for (; *l && *r && n && *l == *r; l++, r++, n--)
    1640:	00a68e63          	beq	a3,a0,165c <strncmp+0x30>
    1644:	0505                	addi	a0,a0,1
    1646:	00e79b63          	bne	a5,a4,165c <strncmp+0x30>
    164a:	00054703          	lbu	a4,0(a0)
    164e:	0005c783          	lbu	a5,0(a1)
    1652:	cb19                	beqz	a4,1668 <strncmp+0x3c>
    1654:	0005c783          	lbu	a5,0(a1)
    1658:	0585                	addi	a1,a1,1
    165a:	f3fd                	bnez	a5,1640 <strncmp+0x14>
        ;
    return *l - *r;
    165c:	0007051b          	sext.w	a0,a4
    1660:	9d1d                	subw	a0,a0,a5
    1662:	8082                	ret
        return 0;
    1664:	4501                	li	a0,0
}
    1666:	8082                	ret
    1668:	4501                	li	a0,0
    return *l - *r;
    166a:	9d1d                	subw	a0,a0,a5
    166c:	8082                	ret

000000000000166e <strlen>:
size_t strlen(const char* s)
{
    const char* a = s;
    typedef size_t __attribute__((__may_alias__)) word;
    const word* w;
    for (; (uintptr_t)s % SS; s++)
    166e:	00757793          	andi	a5,a0,7
    1672:	cf89                	beqz	a5,168c <strlen+0x1e>
    1674:	87aa                	mv	a5,a0
    1676:	a029                	j	1680 <strlen+0x12>
    1678:	0785                	addi	a5,a5,1
    167a:	0077f713          	andi	a4,a5,7
    167e:	cb01                	beqz	a4,168e <strlen+0x20>
        if (!*s)
    1680:	0007c703          	lbu	a4,0(a5)
    1684:	fb75                	bnez	a4,1678 <strlen+0xa>
    for (w = (const void*)s; !HASZERO(*w); w++)
        ;
    s = (const void*)w;
    for (; *s; s++)
        ;
    return s - a;
    1686:	40a78533          	sub	a0,a5,a0
}
    168a:	8082                	ret
    for (; (uintptr_t)s % SS; s++)
    168c:	87aa                	mv	a5,a0
    for (w = (const void*)s; !HASZERO(*w); w++)
    168e:	6394                	ld	a3,0(a5)
    1690:	00000597          	auipc	a1,0x0
    1694:	4805b583          	ld	a1,1152(a1) # 1b10 <main+0x46>
    1698:	00000617          	auipc	a2,0x0
    169c:	48063603          	ld	a2,1152(a2) # 1b18 <main+0x4e>
    16a0:	a019                	j	16a6 <strlen+0x38>
    16a2:	6794                	ld	a3,8(a5)
    16a4:	07a1                	addi	a5,a5,8
    16a6:	00b68733          	add	a4,a3,a1
    16aa:	fff6c693          	not	a3,a3
    16ae:	8f75                	and	a4,a4,a3
    16b0:	8f71                	and	a4,a4,a2
    16b2:	db65                	beqz	a4,16a2 <strlen+0x34>
    for (; *s; s++)
    16b4:	0007c703          	lbu	a4,0(a5)
    16b8:	d779                	beqz	a4,1686 <strlen+0x18>
    16ba:	0017c703          	lbu	a4,1(a5)
    16be:	0785                	addi	a5,a5,1
    16c0:	d379                	beqz	a4,1686 <strlen+0x18>
    16c2:	0017c703          	lbu	a4,1(a5)
    16c6:	0785                	addi	a5,a5,1
    16c8:	fb6d                	bnez	a4,16ba <strlen+0x4c>
    16ca:	bf75                	j	1686 <strlen+0x18>

00000000000016cc <memchr>:

void* memchr(const void* src, int c, size_t n)
{
    const unsigned char* s = src;
    c = (unsigned char)c;
    for (; ((uintptr_t)s & ALIGN) && n && *s != c; s++, n--)
    16cc:	00757713          	andi	a4,a0,7
{
    16d0:	87aa                	mv	a5,a0
    c = (unsigned char)c;
    16d2:	0ff5f593          	andi	a1,a1,255
    for (; ((uintptr_t)s & ALIGN) && n && *s != c; s++, n--)
    16d6:	cb19                	beqz	a4,16ec <memchr+0x20>
    16d8:	ce25                	beqz	a2,1750 <memchr+0x84>
    16da:	0007c703          	lbu	a4,0(a5)
    16de:	04b70e63          	beq	a4,a1,173a <memchr+0x6e>
    16e2:	0785                	addi	a5,a5,1
    16e4:	0077f713          	andi	a4,a5,7
    16e8:	167d                	addi	a2,a2,-1
    16ea:	f77d                	bnez	a4,16d8 <memchr+0xc>
            ;
        s = (const void*)w;
    }
    for (; n && *s != c; s++, n--)
        ;
    return n ? (void*)s : 0;
    16ec:	4501                	li	a0,0
    if (n && *s != c) {
    16ee:	c235                	beqz	a2,1752 <memchr+0x86>
    16f0:	0007c703          	lbu	a4,0(a5)
    16f4:	04b70363          	beq	a4,a1,173a <memchr+0x6e>
        size_t k = ONES * c;
    16f8:	00000517          	auipc	a0,0x0
    16fc:	42853503          	ld	a0,1064(a0) # 1b20 <main+0x56>
        for (w = (const void*)s; n >= SS && !HASZERO(*w ^ k); w++, n -= SS)
    1700:	471d                	li	a4,7
        size_t k = ONES * c;
    1702:	02a58533          	mul	a0,a1,a0
        for (w = (const void*)s; n >= SS && !HASZERO(*w ^ k); w++, n -= SS)
    1706:	02c77a63          	bgeu	a4,a2,173a <memchr+0x6e>
    170a:	00000897          	auipc	a7,0x0
    170e:	4068b883          	ld	a7,1030(a7) # 1b10 <main+0x46>
    1712:	00000817          	auipc	a6,0x0
    1716:	40683803          	ld	a6,1030(a6) # 1b18 <main+0x4e>
    171a:	431d                	li	t1,7
    171c:	a029                	j	1726 <memchr+0x5a>
    171e:	1661                	addi	a2,a2,-8
    1720:	07a1                	addi	a5,a5,8
    1722:	02c37963          	bgeu	t1,a2,1754 <memchr+0x88>
    1726:	6398                	ld	a4,0(a5)
    1728:	8f29                	xor	a4,a4,a0
    172a:	011706b3          	add	a3,a4,a7
    172e:	fff74713          	not	a4,a4
    1732:	8f75                	and	a4,a4,a3
    1734:	01077733          	and	a4,a4,a6
    1738:	d37d                	beqz	a4,171e <memchr+0x52>
    173a:	853e                	mv	a0,a5
    173c:	97b2                	add	a5,a5,a2
    173e:	a021                	j	1746 <memchr+0x7a>
    for (; n && *s != c; s++, n--)
    1740:	0505                	addi	a0,a0,1
    1742:	00f50763          	beq	a0,a5,1750 <memchr+0x84>
    1746:	00054703          	lbu	a4,0(a0)
    174a:	feb71be3          	bne	a4,a1,1740 <memchr+0x74>
    174e:	8082                	ret
    return n ? (void*)s : 0;
    1750:	4501                	li	a0,0
}
    1752:	8082                	ret
    return n ? (void*)s : 0;
    1754:	4501                	li	a0,0
    for (; n && *s != c; s++, n--)
    1756:	f275                	bnez	a2,173a <memchr+0x6e>
}
    1758:	8082                	ret

000000000000175a <strnlen>:

size_t strnlen(const char* s, size_t n)
{
    175a:	1101                	addi	sp,sp,-32
    175c:	e822                	sd	s0,16(sp)
    const char* p = memchr(s, 0, n);
    175e:	862e                	mv	a2,a1
{
    1760:	842e                	mv	s0,a1
    const char* p = memchr(s, 0, n);
    1762:	4581                	li	a1,0
{
    1764:	e426                	sd	s1,8(sp)
    1766:	ec06                	sd	ra,24(sp)
    1768:	84aa                	mv	s1,a0
    const char* p = memchr(s, 0, n);
    176a:	f63ff0ef          	jal	ra,16cc <memchr>
    return p ? p - s : n;
    176e:	c519                	beqz	a0,177c <strnlen+0x22>
}
    1770:	60e2                	ld	ra,24(sp)
    1772:	6442                	ld	s0,16(sp)
    return p ? p - s : n;
    1774:	8d05                	sub	a0,a0,s1
}
    1776:	64a2                	ld	s1,8(sp)
    1778:	6105                	addi	sp,sp,32
    177a:	8082                	ret
    177c:	60e2                	ld	ra,24(sp)
    return p ? p - s : n;
    177e:	8522                	mv	a0,s0
}
    1780:	6442                	ld	s0,16(sp)
    1782:	64a2                	ld	s1,8(sp)
    1784:	6105                	addi	sp,sp,32
    1786:	8082                	ret

0000000000001788 <stpcpy>:
char* stpcpy(char* restrict d, const char* s)
{
    typedef size_t __attribute__((__may_alias__)) word;
    word* wd;
    const word* ws;
    if ((uintptr_t)s % SS == (uintptr_t)d % SS) {
    1788:	00b547b3          	xor	a5,a0,a1
    178c:	8b9d                	andi	a5,a5,7
    178e:	eb95                	bnez	a5,17c2 <stpcpy+0x3a>
        for (; (uintptr_t)s % SS; s++, d++)
    1790:	0075f793          	andi	a5,a1,7
    1794:	e7b1                	bnez	a5,17e0 <stpcpy+0x58>
            if (!(*d = *s))
                return d;
        wd = (void*)d;
        ws = (const void*)s;
        for (; !HASZERO(*ws); *wd++ = *ws++)
    1796:	6198                	ld	a4,0(a1)
    1798:	00000617          	auipc	a2,0x0
    179c:	37863603          	ld	a2,888(a2) # 1b10 <main+0x46>
    17a0:	00000817          	auipc	a6,0x0
    17a4:	37883803          	ld	a6,888(a6) # 1b18 <main+0x4e>
    17a8:	a029                	j	17b2 <stpcpy+0x2a>
    17aa:	e118                	sd	a4,0(a0)
    17ac:	6598                	ld	a4,8(a1)
    17ae:	05a1                	addi	a1,a1,8
    17b0:	0521                	addi	a0,a0,8
    17b2:	00c707b3          	add	a5,a4,a2
    17b6:	fff74693          	not	a3,a4
    17ba:	8ff5                	and	a5,a5,a3
    17bc:	0107f7b3          	and	a5,a5,a6
    17c0:	d7ed                	beqz	a5,17aa <stpcpy+0x22>
            ;
        d = (void*)wd;
        s = (const void*)ws;
    }
    for (; (*d = *s); s++, d++)
    17c2:	0005c783          	lbu	a5,0(a1)
    17c6:	00f50023          	sb	a5,0(a0)
    17ca:	c785                	beqz	a5,17f2 <stpcpy+0x6a>
    17cc:	0015c783          	lbu	a5,1(a1)
    17d0:	0505                	addi	a0,a0,1
    17d2:	0585                	addi	a1,a1,1
    17d4:	00f50023          	sb	a5,0(a0)
    17d8:	fbf5                	bnez	a5,17cc <stpcpy+0x44>
        ;
    return d;
}
    17da:	8082                	ret
        for (; (uintptr_t)s % SS; s++, d++)
    17dc:	0505                	addi	a0,a0,1
    17de:	df45                	beqz	a4,1796 <stpcpy+0xe>
            if (!(*d = *s))
    17e0:	0005c783          	lbu	a5,0(a1)
        for (; (uintptr_t)s % SS; s++, d++)
    17e4:	0585                	addi	a1,a1,1
    17e6:	0075f713          	andi	a4,a1,7
            if (!(*d = *s))
    17ea:	00f50023          	sb	a5,0(a0)
    17ee:	f7fd                	bnez	a5,17dc <stpcpy+0x54>
}
    17f0:	8082                	ret
    17f2:	8082                	ret

00000000000017f4 <stpncpy>:
char* stpncpy(char* restrict d, const char* s, size_t n)
{
    typedef size_t __attribute__((__may_alias__)) word;
    word* wd;
    const word* ws;
    if (((uintptr_t)s & ALIGN) == ((uintptr_t)d & ALIGN)) {
    17f4:	00b547b3          	xor	a5,a0,a1
    17f8:	8b9d                	andi	a5,a5,7
    17fa:	1a079863          	bnez	a5,19aa <stpncpy+0x1b6>
        for (; ((uintptr_t)s & ALIGN) && n && (*d = *s); n--, s++, d++)
    17fe:	0075f793          	andi	a5,a1,7
    1802:	16078463          	beqz	a5,196a <stpncpy+0x176>
    1806:	ea01                	bnez	a2,1816 <stpncpy+0x22>
    1808:	a421                	j	1a10 <stpncpy+0x21c>
    180a:	167d                	addi	a2,a2,-1
    180c:	0505                	addi	a0,a0,1
    180e:	14070e63          	beqz	a4,196a <stpncpy+0x176>
    1812:	1a060863          	beqz	a2,19c2 <stpncpy+0x1ce>
    1816:	0005c783          	lbu	a5,0(a1)
    181a:	0585                	addi	a1,a1,1
    181c:	0075f713          	andi	a4,a1,7
    1820:	00f50023          	sb	a5,0(a0)
    1824:	f3fd                	bnez	a5,180a <stpncpy+0x16>
    1826:	4805                	li	a6,1
    1828:	1a061863          	bnez	a2,19d8 <stpncpy+0x1e4>
    182c:	40a007b3          	neg	a5,a0
    1830:	8b9d                	andi	a5,a5,7
    1832:	4681                	li	a3,0
    1834:	18061a63          	bnez	a2,19c8 <stpncpy+0x1d4>
    1838:	00778713          	addi	a4,a5,7
    183c:	45ad                	li	a1,11
    183e:	18b76363          	bltu	a4,a1,19c4 <stpncpy+0x1d0>
    1842:	1ae6eb63          	bltu	a3,a4,19f8 <stpncpy+0x204>
    1846:	1a078363          	beqz	a5,19ec <stpncpy+0x1f8>
    for(int i = 0; i < n; ++i, *(p++) = c);
    184a:	00050023          	sb	zero,0(a0)
    184e:	4685                	li	a3,1
    1850:	00150713          	addi	a4,a0,1
    1854:	18d78f63          	beq	a5,a3,19f2 <stpncpy+0x1fe>
    1858:	000500a3          	sb	zero,1(a0)
    185c:	4689                	li	a3,2
    185e:	00250713          	addi	a4,a0,2
    1862:	18d78e63          	beq	a5,a3,19fe <stpncpy+0x20a>
    1866:	00050123          	sb	zero,2(a0)
    186a:	468d                	li	a3,3
    186c:	00350713          	addi	a4,a0,3
    1870:	16d78c63          	beq	a5,a3,19e8 <stpncpy+0x1f4>
    1874:	000501a3          	sb	zero,3(a0)
    1878:	4691                	li	a3,4
    187a:	00450713          	addi	a4,a0,4
    187e:	18d78263          	beq	a5,a3,1a02 <stpncpy+0x20e>
    1882:	00050223          	sb	zero,4(a0)
    1886:	4695                	li	a3,5
    1888:	00550713          	addi	a4,a0,5
    188c:	16d78d63          	beq	a5,a3,1a06 <stpncpy+0x212>
    1890:	000502a3          	sb	zero,5(a0)
    1894:	469d                	li	a3,7
    1896:	00650713          	addi	a4,a0,6
    189a:	16d79863          	bne	a5,a3,1a0a <stpncpy+0x216>
    189e:	00750713          	addi	a4,a0,7
    18a2:	00050323          	sb	zero,6(a0)
    18a6:	40f80833          	sub	a6,a6,a5
    18aa:	ff887593          	andi	a1,a6,-8
    18ae:	97aa                	add	a5,a5,a0
    18b0:	95be                	add	a1,a1,a5
    18b2:	0007b023          	sd	zero,0(a5)
    18b6:	07a1                	addi	a5,a5,8
    18b8:	feb79de3          	bne	a5,a1,18b2 <stpncpy+0xbe>
    18bc:	ff887593          	andi	a1,a6,-8
    18c0:	9ead                	addw	a3,a3,a1
    18c2:	00b707b3          	add	a5,a4,a1
    18c6:	12b80863          	beq	a6,a1,19f6 <stpncpy+0x202>
    18ca:	00078023          	sb	zero,0(a5)
    18ce:	0016871b          	addiw	a4,a3,1
    18d2:	0ec77863          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    18d6:	000780a3          	sb	zero,1(a5)
    18da:	0026871b          	addiw	a4,a3,2
    18de:	0ec77263          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    18e2:	00078123          	sb	zero,2(a5)
    18e6:	0036871b          	addiw	a4,a3,3
    18ea:	0cc77c63          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    18ee:	000781a3          	sb	zero,3(a5)
    18f2:	0046871b          	addiw	a4,a3,4
    18f6:	0cc77663          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    18fa:	00078223          	sb	zero,4(a5)
    18fe:	0056871b          	addiw	a4,a3,5
    1902:	0cc77063          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    1906:	000782a3          	sb	zero,5(a5)
    190a:	0066871b          	addiw	a4,a3,6
    190e:	0ac77a63          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    1912:	00078323          	sb	zero,6(a5)
    1916:	0076871b          	addiw	a4,a3,7
    191a:	0ac77463          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    191e:	000783a3          	sb	zero,7(a5)
    1922:	0086871b          	addiw	a4,a3,8
    1926:	08c77e63          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    192a:	00078423          	sb	zero,8(a5)
    192e:	0096871b          	addiw	a4,a3,9
    1932:	08c77863          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    1936:	000784a3          	sb	zero,9(a5)
    193a:	00a6871b          	addiw	a4,a3,10
    193e:	08c77263          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    1942:	00078523          	sb	zero,10(a5)
    1946:	00b6871b          	addiw	a4,a3,11
    194a:	06c77c63          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    194e:	000785a3          	sb	zero,11(a5)
    1952:	00c6871b          	addiw	a4,a3,12
    1956:	06c77663          	bgeu	a4,a2,19c2 <stpncpy+0x1ce>
    195a:	00078623          	sb	zero,12(a5)
    195e:	26b5                	addiw	a3,a3,13
    1960:	06c6f163          	bgeu	a3,a2,19c2 <stpncpy+0x1ce>
    1964:	000786a3          	sb	zero,13(a5)
    1968:	8082                	ret
            ;
        if (!n || !*s)
    196a:	c645                	beqz	a2,1a12 <stpncpy+0x21e>
    196c:	0005c783          	lbu	a5,0(a1)
    1970:	ea078be3          	beqz	a5,1826 <stpncpy+0x32>
            goto tail;
        wd = (void*)d;
        ws = (const void*)s;
        for (; n >= sizeof(size_t) && !HASZERO(*ws); n -= sizeof(size_t), ws++, wd++)
    1974:	479d                	li	a5,7
    1976:	02c7ff63          	bgeu	a5,a2,19b4 <stpncpy+0x1c0>
    197a:	00000897          	auipc	a7,0x0
    197e:	1968b883          	ld	a7,406(a7) # 1b10 <main+0x46>
    1982:	00000817          	auipc	a6,0x0
    1986:	19683803          	ld	a6,406(a6) # 1b18 <main+0x4e>
    198a:	431d                	li	t1,7
    198c:	6198                	ld	a4,0(a1)
    198e:	011707b3          	add	a5,a4,a7
    1992:	fff74693          	not	a3,a4
    1996:	8ff5                	and	a5,a5,a3
    1998:	0107f7b3          	and	a5,a5,a6
    199c:	ef81                	bnez	a5,19b4 <stpncpy+0x1c0>
            *wd = *ws;
    199e:	e118                	sd	a4,0(a0)
        for (; n >= sizeof(size_t) && !HASZERO(*ws); n -= sizeof(size_t), ws++, wd++)
    19a0:	1661                	addi	a2,a2,-8
    19a2:	05a1                	addi	a1,a1,8
    19a4:	0521                	addi	a0,a0,8
    19a6:	fec363e3          	bltu	t1,a2,198c <stpncpy+0x198>
        d = (void*)wd;
        s = (const void*)ws;
    }
    for (; n && (*d = *s); n--, s++, d++)
    19aa:	e609                	bnez	a2,19b4 <stpncpy+0x1c0>
    19ac:	a08d                	j	1a0e <stpncpy+0x21a>
    19ae:	167d                	addi	a2,a2,-1
    19b0:	0505                	addi	a0,a0,1
    19b2:	ca01                	beqz	a2,19c2 <stpncpy+0x1ce>
    19b4:	0005c783          	lbu	a5,0(a1)
    19b8:	0585                	addi	a1,a1,1
    19ba:	00f50023          	sb	a5,0(a0)
    19be:	fbe5                	bnez	a5,19ae <stpncpy+0x1ba>
        ;
tail:
    19c0:	b59d                	j	1826 <stpncpy+0x32>
    memset(d, 0, n);
    return d;
    19c2:	8082                	ret
    19c4:	472d                	li	a4,11
    19c6:	bdb5                	j	1842 <stpncpy+0x4e>
    19c8:	00778713          	addi	a4,a5,7
    19cc:	45ad                	li	a1,11
    19ce:	fff60693          	addi	a3,a2,-1
    19d2:	e6b778e3          	bgeu	a4,a1,1842 <stpncpy+0x4e>
    19d6:	b7fd                	j	19c4 <stpncpy+0x1d0>
    19d8:	40a007b3          	neg	a5,a0
    19dc:	8832                	mv	a6,a2
    19de:	8b9d                	andi	a5,a5,7
    19e0:	4681                	li	a3,0
    19e2:	e4060be3          	beqz	a2,1838 <stpncpy+0x44>
    19e6:	b7cd                	j	19c8 <stpncpy+0x1d4>
    for(int i = 0; i < n; ++i, *(p++) = c);
    19e8:	468d                	li	a3,3
    19ea:	bd75                	j	18a6 <stpncpy+0xb2>
    19ec:	872a                	mv	a4,a0
    19ee:	4681                	li	a3,0
    19f0:	bd5d                	j	18a6 <stpncpy+0xb2>
    19f2:	4685                	li	a3,1
    19f4:	bd4d                	j	18a6 <stpncpy+0xb2>
    19f6:	8082                	ret
    19f8:	87aa                	mv	a5,a0
    19fa:	4681                	li	a3,0
    19fc:	b5f9                	j	18ca <stpncpy+0xd6>
    19fe:	4689                	li	a3,2
    1a00:	b55d                	j	18a6 <stpncpy+0xb2>
    1a02:	4691                	li	a3,4
    1a04:	b54d                	j	18a6 <stpncpy+0xb2>
    1a06:	4695                	li	a3,5
    1a08:	bd79                	j	18a6 <stpncpy+0xb2>
    1a0a:	4699                	li	a3,6
    1a0c:	bd69                	j	18a6 <stpncpy+0xb2>
    1a0e:	8082                	ret
    1a10:	8082                	ret
    1a12:	8082                	ret

0000000000001a14 <open>:
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
}

static inline long __syscall3(long n, long a, long b, long c)
{
    register long a7 __asm__("a7") = n;
    1a14:	03800893          	li	a7,56
    register long a0 __asm__("a0") = a;
    register long a1 __asm__("a1") = b;
    register long a2 __asm__("a2") = c;
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1a18:	00000073          	ecall

#include "syscall.h"

int open(const char *path, int flags, int mode) {
    return syscall(SYS_openat, path, flags, mode);
}
    1a1c:	2501                	sext.w	a0,a0
    1a1e:	8082                	ret

0000000000001a20 <close>:
    register long a7 __asm__("a7") = n;
    1a20:	03900893          	li	a7,57
    __asm_syscall("r"(a7), "0"(a0))
    1a24:	00000073          	ecall

int close(int fd) {
    return syscall(SYS_close, fd);
}
    1a28:	2501                	sext.w	a0,a0
    1a2a:	8082                	ret

0000000000001a2c <read>:
    register long a7 __asm__("a7") = n;
    1a2c:	03f00893          	li	a7,63
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1a30:	00000073          	ecall

ssize_t read(int fd, void *buf, unsigned long long len) {
    return syscall(SYS_read, fd, buf, len);
}
    1a34:	8082                	ret

0000000000001a36 <write>:
    register long a7 __asm__("a7") = n;
    1a36:	04000893          	li	a7,64
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1a3a:	00000073          	ecall

ssize_t write(int fd, const void *buf, unsigned long long len) {
    return syscall(SYS_write, fd, buf, len);
}
    1a3e:	8082                	ret

0000000000001a40 <getpid>:
    register long a7 __asm__("a7") = n;
    1a40:	0ac00893          	li	a7,172
    __asm_syscall("r"(a7))
    1a44:	00000073          	ecall

int getpid(void) {
    return syscall(SYS_getpid);
}
    1a48:	2501                	sext.w	a0,a0
    1a4a:	8082                	ret

0000000000001a4c <sched_yield>:
    register long a7 __asm__("a7") = n;
    1a4c:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1a50:	00000073          	ecall

int sched_yield(void) {
    return syscall(SYS_sched_yield);
}
    1a54:	2501                	sext.w	a0,a0
    1a56:	8082                	ret

0000000000001a58 <fork>:
    register long a7 __asm__("a7") = n;
    1a58:	0dc00893          	li	a7,220
    __asm_syscall("r"(a7))
    1a5c:	00000073          	ecall

int fork(void) {
    return syscall(SYS_clone);
}
    1a60:	2501                	sext.w	a0,a0
    1a62:	8082                	ret

0000000000001a64 <exit>:
    register long a7 __asm__("a7") = n;
    1a64:	05d00893          	li	a7,93
    __asm_syscall("r"(a7), "0"(a0))
    1a68:	00000073          	ecall

void exit(int code) {
    syscall(SYS_exit, code);
}
    1a6c:	8082                	ret

0000000000001a6e <wait>:
    register long a7 __asm__("a7") = n;
    1a6e:	10400893          	li	a7,260
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
    1a72:	00000073          	ecall

int wait(int pid, int* code) {
    return syscall(SYS_wait4, pid, code);
}
    1a76:	2501                	sext.w	a0,a0
    1a78:	8082                	ret

0000000000001a7a <exec>:
    register long a7 __asm__("a7") = n;
    1a7a:	0dd00893          	li	a7,221
    __asm_syscall("r"(a7), "0"(a0))
    1a7e:	00000073          	ecall

int exec(char* name) {
    return syscall(SYS_execve, name);
}
    1a82:	2501                	sext.w	a0,a0
    1a84:	8082                	ret

0000000000001a86 <get_time>:
    register long a7 __asm__("a7") = n;
    1a86:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1a8a:	00000073          	ecall

uint64 get_time() {
    return syscall(SYS_times);
}
    1a8e:	8082                	ret

0000000000001a90 <sleep>:

int sleep(unsigned long long time) {
    1a90:	872a                	mv	a4,a0
    register long a7 __asm__("a7") = n;
    1a92:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1a96:	00000073          	ecall
    1a9a:	87aa                	mv	a5,a0
    1a9c:	00000073          	ecall
    unsigned long long s = get_time();
    while(get_time() < s + time) {
    1aa0:	97ba                	add	a5,a5,a4
    1aa2:	00f57c63          	bgeu	a0,a5,1aba <sleep+0x2a>
    register long a7 __asm__("a7") = n;
    1aa6:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1aaa:	00000073          	ecall
    register long a7 __asm__("a7") = n;
    1aae:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1ab2:	00000073          	ecall
    1ab6:	fef568e3          	bltu	a0,a5,1aa6 <sleep+0x16>
        sched_yield();
    }
    return 0;
}
    1aba:	4501                	li	a0,0
    1abc:	8082                	ret

0000000000001abe <pipe>:
    register long a7 __asm__("a7") = n;
    1abe:	03b00893          	li	a7,59
    __asm_syscall("r"(a7), "0"(a0))
    1ac2:	00000073          	ecall

int pipe(void* p) {
    return syscall(SYS_pipe2, p);
    1ac6:	2501                	sext.w	a0,a0
    1ac8:	8082                	ret

Disassembly of section .text.startup:

0000000000001aca <main>:
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    1aca:	1141                	addi	sp,sp,-16
    puts("execute hello.bin");
    1acc:	00000517          	auipc	a0,0x0
    1ad0:	02450513          	addi	a0,a0,36 # 1af0 <main+0x26>
int main() {
    1ad4:	e406                	sd	ra,8(sp)
    puts("execute hello.bin");
    1ad6:	d84ff0ef          	jal	ra,105a <puts>
    exec("hello.bin");
    1ada:	00000517          	auipc	a0,0x0
    1ade:	01e50513          	addi	a0,a0,30 # 1af8 <main+0x2e>
    1ae2:	f99ff0ef          	jal	ra,1a7a <exec>
    return 0;
    1ae6:	60a2                	ld	ra,8(sp)
    1ae8:	4501                	li	a0,0
    1aea:	0141                	addi	sp,sp,16
    1aec:	8082                	ret
