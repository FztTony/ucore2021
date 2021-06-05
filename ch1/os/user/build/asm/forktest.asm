
/home/tonyfu/riscv/ucore-Tutorial/user/build/riscv64/forktest:     file format elf64-littleriscv


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
    100a:	30d000ef          	jal	ra,1b16 <main>
    100e:	2a3000ef          	jal	ra,1ab0 <exit>
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
    102a:	24f000ef          	jal	ra,1a78 <read>
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
    1042:	c3258593          	addi	a1,a1,-974 # 1c70 <put.1058>
    return write(stdout, put, 1);
    1046:	4605                	li	a2,1
    1048:	4501                	li	a0,0
    put[0] = c;
    104a:	00f58023          	sb	a5,0(a1)
    return write(stdout, put, 1);
    104e:	235000ef          	jal	ra,1a82 <write>
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
    1062:	658000ef          	jal	ra,16ba <strlen>
    1066:	862a                	mv	a2,a0
    1068:	85a2                	mv	a1,s0
    106a:	4501                	li	a0,0
    106c:	217000ef          	jal	ra,1a82 <write>
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
    1082:	bf258593          	addi	a1,a1,-1038 # 1c70 <put.1058>
    1086:	47a9                	li	a5,10
    return write(stdout, put, 1);
    1088:	4605                	li	a2,1
    108a:	4501                	li	a0,0
    put[0] = c;
    108c:	00f58023          	sb	a5,0(a1)
    return write(stdout, put, 1);
    1090:	1f3000ef          	jal	ra,1a82 <write>
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
    10e8:	b8c40413          	addi	s0,s0,-1140 # 1c70 <put.1058>
    10ec:	03000c93          	li	s9,48
    10f0:	07800c13          	li	s8,120
    10f4:	00001b17          	auipc	s6,0x1
    10f8:	b64b0b13          	addi	s6,s6,-1180 # 1c58 <digits>
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
    11a8:	0db000ef          	jal	ra,1a82 <write>
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
    1242:	041000ef          	jal	ra,1a82 <write>
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
    125e:	a1658593          	addi	a1,a1,-1514 # 1c70 <put.1058>
    1262:	4501                	li	a0,0
    put[0] = c;
    1264:	00640023          	sb	t1,0(s0)
            continue;
    1268:	893e                	mv	s2,a5
    return write(stdout, put, 1);
    126a:	019000ef          	jal	ra,1a82 <write>
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
    1294:	7ee000ef          	jal	ra,1a82 <write>
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
    12b4:	9c058593          	addi	a1,a1,-1600 # 1c70 <put.1058>
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
    12c8:	7ba000ef          	jal	ra,1a82 <write>
    12cc:	4605                	li	a2,1
    12ce:	00001597          	auipc	a1,0x1
    12d2:	9a258593          	addi	a1,a1,-1630 # 1c70 <put.1058>
    12d6:	4501                	li	a0,0
    put[0] = c;
    12d8:	01840023          	sb	s8,0(s0)
    return write(stdout, put, 1);
    12dc:	44c1                	li	s1,16
    12de:	7a4000ef          	jal	ra,1a82 <write>
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
    12fa:	788000ef          	jal	ra,1a82 <write>
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
    1318:	95c58593          	addi	a1,a1,-1700 # 1c70 <put.1058>
    131c:	4501                	li	a0,0
    put[0] = c;
    131e:	00f40023          	sb	a5,0(s0)
    return write(stdout, put, 1);
    1322:	760000ef          	jal	ra,1a82 <write>
    1326:	4605                	li	a2,1
    1328:	00001597          	auipc	a1,0x1
    132c:	94858593          	addi	a1,a1,-1720 # 1c70 <put.1058>
    1330:	4501                	li	a0,0
    put[0] = c;
    1332:	00940023          	sb	s1,0(s0)
    return write(stdout, put, 1);
    1336:	74c000ef          	jal	ra,1a82 <write>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    133a:	0009c303          	lbu	t1,0(s3)
    133e:	0003071b          	sext.w	a4,t1
    1342:	da031de3          	bnez	t1,10fc <printf+0x5c>
    1346:	bd9d                	j	11bc <printf+0x11c>
    return write(stdout, put, 1);
    1348:	4605                	li	a2,1
    134a:	00001597          	auipc	a1,0x1
    134e:	92658593          	addi	a1,a1,-1754 # 1c70 <put.1058>
    1352:	4501                	li	a0,0
    put[0] = c;
    1354:	01540023          	sb	s5,0(s0)
    return write(stdout, put, 1);
    1358:	72a000ef          	jal	ra,1a82 <write>
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
    138a:	00001497          	auipc	s1,0x1
    138e:	89e48493          	addi	s1,s1,-1890 # 1c28 <main+0x112>
                for (; *s; s++)
    1392:	02800793          	li	a5,40
    1396:	bdcd                	j	1288 <printf+0x1e8>
        buf[i++] = digits[x % base];
    1398:	4785                	li	a5,1
    139a:	b3d5                	j	117e <printf+0xde>
    139c:	4789                	li	a5,2
    139e:	4485                	li	s1,1
    13a0:	bbf9                	j	117e <printf+0xde>

00000000000013a2 <srand>:
#include <unistd.h>

static uint64 seed;

void srand(unsigned s) {
    seed = s - 1;
    13a2:	357d                	addiw	a0,a0,-1
    13a4:	1502                	slli	a0,a0,0x20
    13a6:	9101                	srli	a0,a0,0x20
    13a8:	00001797          	auipc	a5,0x1
    13ac:	8ca7b823          	sd	a0,-1840(a5) # 1c78 <seed>
}
    13b0:	8082                	ret

00000000000013b2 <rand>:

int rand(void) {
    seed = 6364136223846793005ULL * seed + 1;
    13b2:	00001797          	auipc	a5,0x1
    13b6:	8c678793          	addi	a5,a5,-1850 # 1c78 <seed>
    13ba:	6388                	ld	a0,0(a5)
    13bc:	00001717          	auipc	a4,0x1
    13c0:	87c73703          	ld	a4,-1924(a4) # 1c38 <MAX_CHILD+0x8>
    13c4:	02e50533          	mul	a0,a0,a4
    13c8:	0505                	addi	a0,a0,1
    13ca:	e388                	sd	a0,0(a5)
    return seed >> 33;
}
    13cc:	9105                	srli	a0,a0,0x21
    13ce:	8082                	ret

00000000000013d0 <panic>:

void panic(char* m) {
    13d0:	1141                	addi	sp,sp,-16
    13d2:	e406                	sd	ra,8(sp)
    puts(m);
    13d4:	c87ff0ef          	jal	ra,105a <puts>
    exit(-100);
}
    13d8:	60a2                	ld	ra,8(sp)
    exit(-100);
    13da:	f9c00513          	li	a0,-100
}
    13de:	0141                	addi	sp,sp,16
    exit(-100);
    13e0:	6d00006f          	j	1ab0 <exit>

00000000000013e4 <assert>:

void assert(int f, int code) {
    if(!f) {
    13e4:	c111                	beqz	a0,13e8 <assert+0x4>
        exit(code);
    }
    13e6:	8082                	ret
        exit(code);
    13e8:	852e                	mv	a0,a1
    13ea:	6c60006f          	j	1ab0 <exit>

00000000000013ee <isspace>:
#define HIGHS      (ONES * (UCHAR_MAX / 2 + 1))
#define HASZERO(x) (((x)-ONES) & ~(x) & HIGHS)

int isspace(int c)
{
    return c == ' ' || (unsigned)c - '\t' < 5;
    13ee:	02000793          	li	a5,32
    13f2:	00f50663          	beq	a0,a5,13fe <isspace+0x10>
    13f6:	355d                	addiw	a0,a0,-9
    13f8:	00553513          	sltiu	a0,a0,5
    13fc:	8082                	ret
    13fe:	4505                	li	a0,1
}
    1400:	8082                	ret

0000000000001402 <isdigit>:

int isdigit(int c)
{
    return (unsigned)c - '0' < 10;
    1402:	fd05051b          	addiw	a0,a0,-48
}
    1406:	00a53513          	sltiu	a0,a0,10
    140a:	8082                	ret

000000000000140c <atoi>:
    return c == ' ' || (unsigned)c - '\t' < 5;
    140c:	02000613          	li	a2,32
    1410:	4591                	li	a1,4

int atoi(const char* s)
{
    int n = 0, neg = 0;
    while (isspace(*s))
    1412:	00054703          	lbu	a4,0(a0)
    return c == ' ' || (unsigned)c - '\t' < 5;
    1416:	ff77069b          	addiw	a3,a4,-9
    141a:	04c70d63          	beq	a4,a2,1474 <atoi+0x68>
    141e:	0007079b          	sext.w	a5,a4
    1422:	04d5f963          	bgeu	a1,a3,1474 <atoi+0x68>
        s++;
    switch (*s) {
    1426:	02b00693          	li	a3,43
    142a:	04d70a63          	beq	a4,a3,147e <atoi+0x72>
    142e:	02d00693          	li	a3,45
    1432:	06d70463          	beq	a4,a3,149a <atoi+0x8e>
        neg = 1;
    case '+':
        s++;
    }
    /* Compute n as a negative number to avoid overflow on INT_MIN */
    while (isdigit(*s))
    1436:	fd07859b          	addiw	a1,a5,-48
    143a:	4625                	li	a2,9
    143c:	873e                	mv	a4,a5
    143e:	86aa                	mv	a3,a0
    int n = 0, neg = 0;
    1440:	4e01                	li	t3,0
    while (isdigit(*s))
    1442:	04b66a63          	bltu	a2,a1,1496 <atoi+0x8a>
    int n = 0, neg = 0;
    1446:	4501                	li	a0,0
    while (isdigit(*s))
    1448:	4825                	li	a6,9
    144a:	0016c603          	lbu	a2,1(a3)
        n = 10 * n - (*s++ - '0');
    144e:	0025179b          	slliw	a5,a0,0x2
    1452:	9d3d                	addw	a0,a0,a5
    1454:	fd07031b          	addiw	t1,a4,-48
    1458:	0015189b          	slliw	a7,a0,0x1
    while (isdigit(*s))
    145c:	fd06059b          	addiw	a1,a2,-48
        n = 10 * n - (*s++ - '0');
    1460:	0685                	addi	a3,a3,1
    1462:	4068853b          	subw	a0,a7,t1
    while (isdigit(*s))
    1466:	0006071b          	sext.w	a4,a2
    146a:	feb870e3          	bgeu	a6,a1,144a <atoi+0x3e>
    return neg ? n : -n;
    146e:	000e0563          	beqz	t3,1478 <atoi+0x6c>
}
    1472:	8082                	ret
        s++;
    1474:	0505                	addi	a0,a0,1
    1476:	bf71                	j	1412 <atoi+0x6>
    1478:	4113053b          	subw	a0,t1,a7
    147c:	8082                	ret
    while (isdigit(*s))
    147e:	00154783          	lbu	a5,1(a0)
    1482:	4625                	li	a2,9
        s++;
    1484:	00150693          	addi	a3,a0,1
    while (isdigit(*s))
    1488:	fd07859b          	addiw	a1,a5,-48
    148c:	0007871b          	sext.w	a4,a5
    int n = 0, neg = 0;
    1490:	4e01                	li	t3,0
    while (isdigit(*s))
    1492:	fab67ae3          	bgeu	a2,a1,1446 <atoi+0x3a>
    1496:	4501                	li	a0,0
}
    1498:	8082                	ret
    while (isdigit(*s))
    149a:	00154783          	lbu	a5,1(a0)
    149e:	4625                	li	a2,9
        s++;
    14a0:	00150693          	addi	a3,a0,1
    while (isdigit(*s))
    14a4:	fd07859b          	addiw	a1,a5,-48
    14a8:	0007871b          	sext.w	a4,a5
    14ac:	feb665e3          	bltu	a2,a1,1496 <atoi+0x8a>
        neg = 1;
    14b0:	4e05                	li	t3,1
    14b2:	bf51                	j	1446 <atoi+0x3a>

00000000000014b4 <memset>:

void* memset(void* dest, int c, size_t n)
{
    char* p = dest;
    for(int i = 0; i < n; ++i, *(p++) = c);
    14b4:	16060d63          	beqz	a2,162e <memset+0x17a>
    14b8:	40a007b3          	neg	a5,a0
    14bc:	8b9d                	andi	a5,a5,7
    14be:	00778713          	addi	a4,a5,7
    14c2:	482d                	li	a6,11
    14c4:	0ff5f593          	andi	a1,a1,255
    14c8:	fff60693          	addi	a3,a2,-1
    14cc:	17076263          	bltu	a4,a6,1630 <memset+0x17c>
    14d0:	16e6ea63          	bltu	a3,a4,1644 <memset+0x190>
    14d4:	16078563          	beqz	a5,163e <memset+0x18a>
    14d8:	00b50023          	sb	a1,0(a0)
    14dc:	4705                	li	a4,1
    14de:	00150e93          	addi	t4,a0,1
    14e2:	14e78c63          	beq	a5,a4,163a <memset+0x186>
    14e6:	00b500a3          	sb	a1,1(a0)
    14ea:	4709                	li	a4,2
    14ec:	00250e93          	addi	t4,a0,2
    14f0:	14e78d63          	beq	a5,a4,164a <memset+0x196>
    14f4:	00b50123          	sb	a1,2(a0)
    14f8:	470d                	li	a4,3
    14fa:	00350e93          	addi	t4,a0,3
    14fe:	12e78b63          	beq	a5,a4,1634 <memset+0x180>
    1502:	00b501a3          	sb	a1,3(a0)
    1506:	4711                	li	a4,4
    1508:	00450e93          	addi	t4,a0,4
    150c:	14e78163          	beq	a5,a4,164e <memset+0x19a>
    1510:	00b50223          	sb	a1,4(a0)
    1514:	4715                	li	a4,5
    1516:	00550e93          	addi	t4,a0,5
    151a:	12e78c63          	beq	a5,a4,1652 <memset+0x19e>
    151e:	00b502a3          	sb	a1,5(a0)
    1522:	471d                	li	a4,7
    1524:	00650e93          	addi	t4,a0,6
    1528:	12e79763          	bne	a5,a4,1656 <memset+0x1a2>
    152c:	00750e93          	addi	t4,a0,7
    1530:	00b50323          	sb	a1,6(a0)
    1534:	4f1d                	li	t5,7
    1536:	00859713          	slli	a4,a1,0x8
    153a:	8f4d                	or	a4,a4,a1
    153c:	01059e13          	slli	t3,a1,0x10
    1540:	01c76e33          	or	t3,a4,t3
    1544:	01859313          	slli	t1,a1,0x18
    1548:	006e6333          	or	t1,t3,t1
    154c:	02059893          	slli	a7,a1,0x20
    1550:	011368b3          	or	a7,t1,a7
    1554:	02859813          	slli	a6,a1,0x28
    1558:	40f60333          	sub	t1,a2,a5
    155c:	0108e833          	or	a6,a7,a6
    1560:	03059693          	slli	a3,a1,0x30
    1564:	00d866b3          	or	a3,a6,a3
    1568:	03859713          	slli	a4,a1,0x38
    156c:	97aa                	add	a5,a5,a0
    156e:	ff837813          	andi	a6,t1,-8
    1572:	8f55                	or	a4,a4,a3
    1574:	00f806b3          	add	a3,a6,a5
    1578:	e398                	sd	a4,0(a5)
    157a:	07a1                	addi	a5,a5,8
    157c:	fed79ee3          	bne	a5,a3,1578 <memset+0xc4>
    1580:	ff837693          	andi	a3,t1,-8
    1584:	00de87b3          	add	a5,t4,a3
    1588:	01e6873b          	addw	a4,a3,t5
    158c:	0ad30663          	beq	t1,a3,1638 <memset+0x184>
    1590:	00b78023          	sb	a1,0(a5)
    1594:	0017069b          	addiw	a3,a4,1
    1598:	08c6fb63          	bgeu	a3,a2,162e <memset+0x17a>
    159c:	00b780a3          	sb	a1,1(a5)
    15a0:	0027069b          	addiw	a3,a4,2
    15a4:	08c6f563          	bgeu	a3,a2,162e <memset+0x17a>
    15a8:	00b78123          	sb	a1,2(a5)
    15ac:	0037069b          	addiw	a3,a4,3
    15b0:	06c6ff63          	bgeu	a3,a2,162e <memset+0x17a>
    15b4:	00b781a3          	sb	a1,3(a5)
    15b8:	0047069b          	addiw	a3,a4,4
    15bc:	06c6f963          	bgeu	a3,a2,162e <memset+0x17a>
    15c0:	00b78223          	sb	a1,4(a5)
    15c4:	0057069b          	addiw	a3,a4,5
    15c8:	06c6f363          	bgeu	a3,a2,162e <memset+0x17a>
    15cc:	00b782a3          	sb	a1,5(a5)
    15d0:	0067069b          	addiw	a3,a4,6
    15d4:	04c6fd63          	bgeu	a3,a2,162e <memset+0x17a>
    15d8:	00b78323          	sb	a1,6(a5)
    15dc:	0077069b          	addiw	a3,a4,7
    15e0:	04c6f763          	bgeu	a3,a2,162e <memset+0x17a>
    15e4:	00b783a3          	sb	a1,7(a5)
    15e8:	0087069b          	addiw	a3,a4,8
    15ec:	04c6f163          	bgeu	a3,a2,162e <memset+0x17a>
    15f0:	00b78423          	sb	a1,8(a5)
    15f4:	0097069b          	addiw	a3,a4,9
    15f8:	02c6fb63          	bgeu	a3,a2,162e <memset+0x17a>
    15fc:	00b784a3          	sb	a1,9(a5)
    1600:	00a7069b          	addiw	a3,a4,10
    1604:	02c6f563          	bgeu	a3,a2,162e <memset+0x17a>
    1608:	00b78523          	sb	a1,10(a5)
    160c:	00b7069b          	addiw	a3,a4,11
    1610:	00c6ff63          	bgeu	a3,a2,162e <memset+0x17a>
    1614:	00b785a3          	sb	a1,11(a5)
    1618:	00c7069b          	addiw	a3,a4,12
    161c:	00c6f963          	bgeu	a3,a2,162e <memset+0x17a>
    1620:	00b78623          	sb	a1,12(a5)
    1624:	2735                	addiw	a4,a4,13
    1626:	00c77463          	bgeu	a4,a2,162e <memset+0x17a>
    162a:	00b786a3          	sb	a1,13(a5)
    return dest;
}
    162e:	8082                	ret
    1630:	472d                	li	a4,11
    1632:	bd79                	j	14d0 <memset+0x1c>
    for(int i = 0; i < n; ++i, *(p++) = c);
    1634:	4f0d                	li	t5,3
    1636:	b701                	j	1536 <memset+0x82>
    1638:	8082                	ret
    163a:	4f05                	li	t5,1
    163c:	bded                	j	1536 <memset+0x82>
    163e:	8eaa                	mv	t4,a0
    1640:	4f01                	li	t5,0
    1642:	bdd5                	j	1536 <memset+0x82>
    1644:	87aa                	mv	a5,a0
    1646:	4701                	li	a4,0
    1648:	b7a1                	j	1590 <memset+0xdc>
    164a:	4f09                	li	t5,2
    164c:	b5ed                	j	1536 <memset+0x82>
    164e:	4f11                	li	t5,4
    1650:	b5dd                	j	1536 <memset+0x82>
    1652:	4f15                	li	t5,5
    1654:	b5cd                	j	1536 <memset+0x82>
    1656:	4f19                	li	t5,6
    1658:	bdf9                	j	1536 <memset+0x82>

000000000000165a <strcmp>:

int strcmp(const char* l, const char* r)
{
    for (; *l == *r && *l; l++, r++)
    165a:	00054783          	lbu	a5,0(a0)
    165e:	0005c703          	lbu	a4,0(a1)
    1662:	00e79863          	bne	a5,a4,1672 <strcmp+0x18>
    1666:	0505                	addi	a0,a0,1
    1668:	0585                	addi	a1,a1,1
    166a:	fbe5                	bnez	a5,165a <strcmp>
    166c:	4501                	li	a0,0
        ;
    return *(unsigned char*)l - *(unsigned char*)r;
}
    166e:	9d19                	subw	a0,a0,a4
    1670:	8082                	ret
    1672:	0007851b          	sext.w	a0,a5
    1676:	bfe5                	j	166e <strcmp+0x14>

0000000000001678 <strncmp>:

int strncmp(const char* _l, const char* _r, size_t n)
{
    const unsigned char *l = (void*)_l, *r = (void*)_r;
    if (!n--)
    1678:	ce05                	beqz	a2,16b0 <strncmp+0x38>
        return 0;
    for (; *l && *r && n && *l == *r; l++, r++, n--)
    167a:	00054703          	lbu	a4,0(a0)
    167e:	0005c783          	lbu	a5,0(a1)
    1682:	cb0d                	beqz	a4,16b4 <strncmp+0x3c>
    if (!n--)
    1684:	167d                	addi	a2,a2,-1
    1686:	00c506b3          	add	a3,a0,a2
    168a:	a819                	j	16a0 <strncmp+0x28>
    for (; *l && *r && n && *l == *r; l++, r++, n--)
    168c:	00a68e63          	beq	a3,a0,16a8 <strncmp+0x30>
    1690:	0505                	addi	a0,a0,1
    1692:	00e79b63          	bne	a5,a4,16a8 <strncmp+0x30>
    1696:	00054703          	lbu	a4,0(a0)
    169a:	0005c783          	lbu	a5,0(a1)
    169e:	cb19                	beqz	a4,16b4 <strncmp+0x3c>
    16a0:	0005c783          	lbu	a5,0(a1)
    16a4:	0585                	addi	a1,a1,1
    16a6:	f3fd                	bnez	a5,168c <strncmp+0x14>
        ;
    return *l - *r;
    16a8:	0007051b          	sext.w	a0,a4
    16ac:	9d1d                	subw	a0,a0,a5
    16ae:	8082                	ret
        return 0;
    16b0:	4501                	li	a0,0
}
    16b2:	8082                	ret
    16b4:	4501                	li	a0,0
    return *l - *r;
    16b6:	9d1d                	subw	a0,a0,a5
    16b8:	8082                	ret

00000000000016ba <strlen>:
size_t strlen(const char* s)
{
    const char* a = s;
    typedef size_t __attribute__((__may_alias__)) word;
    const word* w;
    for (; (uintptr_t)s % SS; s++)
    16ba:	00757793          	andi	a5,a0,7
    16be:	cf89                	beqz	a5,16d8 <strlen+0x1e>
    16c0:	87aa                	mv	a5,a0
    16c2:	a029                	j	16cc <strlen+0x12>
    16c4:	0785                	addi	a5,a5,1
    16c6:	0077f713          	andi	a4,a5,7
    16ca:	cb01                	beqz	a4,16da <strlen+0x20>
        if (!*s)
    16cc:	0007c703          	lbu	a4,0(a5)
    16d0:	fb75                	bnez	a4,16c4 <strlen+0xa>
    for (w = (const void*)s; !HASZERO(*w); w++)
        ;
    s = (const void*)w;
    for (; *s; s++)
        ;
    return s - a;
    16d2:	40a78533          	sub	a0,a5,a0
}
    16d6:	8082                	ret
    for (; (uintptr_t)s % SS; s++)
    16d8:	87aa                	mv	a5,a0
    for (w = (const void*)s; !HASZERO(*w); w++)
    16da:	6394                	ld	a3,0(a5)
    16dc:	00000597          	auipc	a1,0x0
    16e0:	5645b583          	ld	a1,1380(a1) # 1c40 <MAX_CHILD+0x10>
    16e4:	00000617          	auipc	a2,0x0
    16e8:	56463603          	ld	a2,1380(a2) # 1c48 <MAX_CHILD+0x18>
    16ec:	a019                	j	16f2 <strlen+0x38>
    16ee:	6794                	ld	a3,8(a5)
    16f0:	07a1                	addi	a5,a5,8
    16f2:	00b68733          	add	a4,a3,a1
    16f6:	fff6c693          	not	a3,a3
    16fa:	8f75                	and	a4,a4,a3
    16fc:	8f71                	and	a4,a4,a2
    16fe:	db65                	beqz	a4,16ee <strlen+0x34>
    for (; *s; s++)
    1700:	0007c703          	lbu	a4,0(a5)
    1704:	d779                	beqz	a4,16d2 <strlen+0x18>
    1706:	0017c703          	lbu	a4,1(a5)
    170a:	0785                	addi	a5,a5,1
    170c:	d379                	beqz	a4,16d2 <strlen+0x18>
    170e:	0017c703          	lbu	a4,1(a5)
    1712:	0785                	addi	a5,a5,1
    1714:	fb6d                	bnez	a4,1706 <strlen+0x4c>
    1716:	bf75                	j	16d2 <strlen+0x18>

0000000000001718 <memchr>:

void* memchr(const void* src, int c, size_t n)
{
    const unsigned char* s = src;
    c = (unsigned char)c;
    for (; ((uintptr_t)s & ALIGN) && n && *s != c; s++, n--)
    1718:	00757713          	andi	a4,a0,7
{
    171c:	87aa                	mv	a5,a0
    c = (unsigned char)c;
    171e:	0ff5f593          	andi	a1,a1,255
    for (; ((uintptr_t)s & ALIGN) && n && *s != c; s++, n--)
    1722:	cb19                	beqz	a4,1738 <memchr+0x20>
    1724:	ce25                	beqz	a2,179c <memchr+0x84>
    1726:	0007c703          	lbu	a4,0(a5)
    172a:	04b70e63          	beq	a4,a1,1786 <memchr+0x6e>
    172e:	0785                	addi	a5,a5,1
    1730:	0077f713          	andi	a4,a5,7
    1734:	167d                	addi	a2,a2,-1
    1736:	f77d                	bnez	a4,1724 <memchr+0xc>
            ;
        s = (const void*)w;
    }
    for (; n && *s != c; s++, n--)
        ;
    return n ? (void*)s : 0;
    1738:	4501                	li	a0,0
    if (n && *s != c) {
    173a:	c235                	beqz	a2,179e <memchr+0x86>
    173c:	0007c703          	lbu	a4,0(a5)
    1740:	04b70363          	beq	a4,a1,1786 <memchr+0x6e>
        size_t k = ONES * c;
    1744:	00000517          	auipc	a0,0x0
    1748:	50c53503          	ld	a0,1292(a0) # 1c50 <MAX_CHILD+0x20>
        for (w = (const void*)s; n >= SS && !HASZERO(*w ^ k); w++, n -= SS)
    174c:	471d                	li	a4,7
        size_t k = ONES * c;
    174e:	02a58533          	mul	a0,a1,a0
        for (w = (const void*)s; n >= SS && !HASZERO(*w ^ k); w++, n -= SS)
    1752:	02c77a63          	bgeu	a4,a2,1786 <memchr+0x6e>
    1756:	00000897          	auipc	a7,0x0
    175a:	4ea8b883          	ld	a7,1258(a7) # 1c40 <MAX_CHILD+0x10>
    175e:	00000817          	auipc	a6,0x0
    1762:	4ea83803          	ld	a6,1258(a6) # 1c48 <MAX_CHILD+0x18>
    1766:	431d                	li	t1,7
    1768:	a029                	j	1772 <memchr+0x5a>
    176a:	1661                	addi	a2,a2,-8
    176c:	07a1                	addi	a5,a5,8
    176e:	02c37963          	bgeu	t1,a2,17a0 <memchr+0x88>
    1772:	6398                	ld	a4,0(a5)
    1774:	8f29                	xor	a4,a4,a0
    1776:	011706b3          	add	a3,a4,a7
    177a:	fff74713          	not	a4,a4
    177e:	8f75                	and	a4,a4,a3
    1780:	01077733          	and	a4,a4,a6
    1784:	d37d                	beqz	a4,176a <memchr+0x52>
    1786:	853e                	mv	a0,a5
    1788:	97b2                	add	a5,a5,a2
    178a:	a021                	j	1792 <memchr+0x7a>
    for (; n && *s != c; s++, n--)
    178c:	0505                	addi	a0,a0,1
    178e:	00f50763          	beq	a0,a5,179c <memchr+0x84>
    1792:	00054703          	lbu	a4,0(a0)
    1796:	feb71be3          	bne	a4,a1,178c <memchr+0x74>
    179a:	8082                	ret
    return n ? (void*)s : 0;
    179c:	4501                	li	a0,0
}
    179e:	8082                	ret
    return n ? (void*)s : 0;
    17a0:	4501                	li	a0,0
    for (; n && *s != c; s++, n--)
    17a2:	f275                	bnez	a2,1786 <memchr+0x6e>
}
    17a4:	8082                	ret

00000000000017a6 <strnlen>:

size_t strnlen(const char* s, size_t n)
{
    17a6:	1101                	addi	sp,sp,-32
    17a8:	e822                	sd	s0,16(sp)
    const char* p = memchr(s, 0, n);
    17aa:	862e                	mv	a2,a1
{
    17ac:	842e                	mv	s0,a1
    const char* p = memchr(s, 0, n);
    17ae:	4581                	li	a1,0
{
    17b0:	e426                	sd	s1,8(sp)
    17b2:	ec06                	sd	ra,24(sp)
    17b4:	84aa                	mv	s1,a0
    const char* p = memchr(s, 0, n);
    17b6:	f63ff0ef          	jal	ra,1718 <memchr>
    return p ? p - s : n;
    17ba:	c519                	beqz	a0,17c8 <strnlen+0x22>
}
    17bc:	60e2                	ld	ra,24(sp)
    17be:	6442                	ld	s0,16(sp)
    return p ? p - s : n;
    17c0:	8d05                	sub	a0,a0,s1
}
    17c2:	64a2                	ld	s1,8(sp)
    17c4:	6105                	addi	sp,sp,32
    17c6:	8082                	ret
    17c8:	60e2                	ld	ra,24(sp)
    return p ? p - s : n;
    17ca:	8522                	mv	a0,s0
}
    17cc:	6442                	ld	s0,16(sp)
    17ce:	64a2                	ld	s1,8(sp)
    17d0:	6105                	addi	sp,sp,32
    17d2:	8082                	ret

00000000000017d4 <stpcpy>:
char* stpcpy(char* restrict d, const char* s)
{
    typedef size_t __attribute__((__may_alias__)) word;
    word* wd;
    const word* ws;
    if ((uintptr_t)s % SS == (uintptr_t)d % SS) {
    17d4:	00b547b3          	xor	a5,a0,a1
    17d8:	8b9d                	andi	a5,a5,7
    17da:	eb95                	bnez	a5,180e <stpcpy+0x3a>
        for (; (uintptr_t)s % SS; s++, d++)
    17dc:	0075f793          	andi	a5,a1,7
    17e0:	e7b1                	bnez	a5,182c <stpcpy+0x58>
            if (!(*d = *s))
                return d;
        wd = (void*)d;
        ws = (const void*)s;
        for (; !HASZERO(*ws); *wd++ = *ws++)
    17e2:	6198                	ld	a4,0(a1)
    17e4:	00000617          	auipc	a2,0x0
    17e8:	45c63603          	ld	a2,1116(a2) # 1c40 <MAX_CHILD+0x10>
    17ec:	00000817          	auipc	a6,0x0
    17f0:	45c83803          	ld	a6,1116(a6) # 1c48 <MAX_CHILD+0x18>
    17f4:	a029                	j	17fe <stpcpy+0x2a>
    17f6:	e118                	sd	a4,0(a0)
    17f8:	6598                	ld	a4,8(a1)
    17fa:	05a1                	addi	a1,a1,8
    17fc:	0521                	addi	a0,a0,8
    17fe:	00c707b3          	add	a5,a4,a2
    1802:	fff74693          	not	a3,a4
    1806:	8ff5                	and	a5,a5,a3
    1808:	0107f7b3          	and	a5,a5,a6
    180c:	d7ed                	beqz	a5,17f6 <stpcpy+0x22>
            ;
        d = (void*)wd;
        s = (const void*)ws;
    }
    for (; (*d = *s); s++, d++)
    180e:	0005c783          	lbu	a5,0(a1)
    1812:	00f50023          	sb	a5,0(a0)
    1816:	c785                	beqz	a5,183e <stpcpy+0x6a>
    1818:	0015c783          	lbu	a5,1(a1)
    181c:	0505                	addi	a0,a0,1
    181e:	0585                	addi	a1,a1,1
    1820:	00f50023          	sb	a5,0(a0)
    1824:	fbf5                	bnez	a5,1818 <stpcpy+0x44>
        ;
    return d;
}
    1826:	8082                	ret
        for (; (uintptr_t)s % SS; s++, d++)
    1828:	0505                	addi	a0,a0,1
    182a:	df45                	beqz	a4,17e2 <stpcpy+0xe>
            if (!(*d = *s))
    182c:	0005c783          	lbu	a5,0(a1)
        for (; (uintptr_t)s % SS; s++, d++)
    1830:	0585                	addi	a1,a1,1
    1832:	0075f713          	andi	a4,a1,7
            if (!(*d = *s))
    1836:	00f50023          	sb	a5,0(a0)
    183a:	f7fd                	bnez	a5,1828 <stpcpy+0x54>
}
    183c:	8082                	ret
    183e:	8082                	ret

0000000000001840 <stpncpy>:
char* stpncpy(char* restrict d, const char* s, size_t n)
{
    typedef size_t __attribute__((__may_alias__)) word;
    word* wd;
    const word* ws;
    if (((uintptr_t)s & ALIGN) == ((uintptr_t)d & ALIGN)) {
    1840:	00b547b3          	xor	a5,a0,a1
    1844:	8b9d                	andi	a5,a5,7
    1846:	1a079863          	bnez	a5,19f6 <stpncpy+0x1b6>
        for (; ((uintptr_t)s & ALIGN) && n && (*d = *s); n--, s++, d++)
    184a:	0075f793          	andi	a5,a1,7
    184e:	16078463          	beqz	a5,19b6 <stpncpy+0x176>
    1852:	ea01                	bnez	a2,1862 <stpncpy+0x22>
    1854:	a421                	j	1a5c <stpncpy+0x21c>
    1856:	167d                	addi	a2,a2,-1
    1858:	0505                	addi	a0,a0,1
    185a:	14070e63          	beqz	a4,19b6 <stpncpy+0x176>
    185e:	1a060863          	beqz	a2,1a0e <stpncpy+0x1ce>
    1862:	0005c783          	lbu	a5,0(a1)
    1866:	0585                	addi	a1,a1,1
    1868:	0075f713          	andi	a4,a1,7
    186c:	00f50023          	sb	a5,0(a0)
    1870:	f3fd                	bnez	a5,1856 <stpncpy+0x16>
    1872:	4805                	li	a6,1
    1874:	1a061863          	bnez	a2,1a24 <stpncpy+0x1e4>
    1878:	40a007b3          	neg	a5,a0
    187c:	8b9d                	andi	a5,a5,7
    187e:	4681                	li	a3,0
    1880:	18061a63          	bnez	a2,1a14 <stpncpy+0x1d4>
    1884:	00778713          	addi	a4,a5,7
    1888:	45ad                	li	a1,11
    188a:	18b76363          	bltu	a4,a1,1a10 <stpncpy+0x1d0>
    188e:	1ae6eb63          	bltu	a3,a4,1a44 <stpncpy+0x204>
    1892:	1a078363          	beqz	a5,1a38 <stpncpy+0x1f8>
    for(int i = 0; i < n; ++i, *(p++) = c);
    1896:	00050023          	sb	zero,0(a0)
    189a:	4685                	li	a3,1
    189c:	00150713          	addi	a4,a0,1
    18a0:	18d78f63          	beq	a5,a3,1a3e <stpncpy+0x1fe>
    18a4:	000500a3          	sb	zero,1(a0)
    18a8:	4689                	li	a3,2
    18aa:	00250713          	addi	a4,a0,2
    18ae:	18d78e63          	beq	a5,a3,1a4a <stpncpy+0x20a>
    18b2:	00050123          	sb	zero,2(a0)
    18b6:	468d                	li	a3,3
    18b8:	00350713          	addi	a4,a0,3
    18bc:	16d78c63          	beq	a5,a3,1a34 <stpncpy+0x1f4>
    18c0:	000501a3          	sb	zero,3(a0)
    18c4:	4691                	li	a3,4
    18c6:	00450713          	addi	a4,a0,4
    18ca:	18d78263          	beq	a5,a3,1a4e <stpncpy+0x20e>
    18ce:	00050223          	sb	zero,4(a0)
    18d2:	4695                	li	a3,5
    18d4:	00550713          	addi	a4,a0,5
    18d8:	16d78d63          	beq	a5,a3,1a52 <stpncpy+0x212>
    18dc:	000502a3          	sb	zero,5(a0)
    18e0:	469d                	li	a3,7
    18e2:	00650713          	addi	a4,a0,6
    18e6:	16d79863          	bne	a5,a3,1a56 <stpncpy+0x216>
    18ea:	00750713          	addi	a4,a0,7
    18ee:	00050323          	sb	zero,6(a0)
    18f2:	40f80833          	sub	a6,a6,a5
    18f6:	ff887593          	andi	a1,a6,-8
    18fa:	97aa                	add	a5,a5,a0
    18fc:	95be                	add	a1,a1,a5
    18fe:	0007b023          	sd	zero,0(a5)
    1902:	07a1                	addi	a5,a5,8
    1904:	feb79de3          	bne	a5,a1,18fe <stpncpy+0xbe>
    1908:	ff887593          	andi	a1,a6,-8
    190c:	9ead                	addw	a3,a3,a1
    190e:	00b707b3          	add	a5,a4,a1
    1912:	12b80863          	beq	a6,a1,1a42 <stpncpy+0x202>
    1916:	00078023          	sb	zero,0(a5)
    191a:	0016871b          	addiw	a4,a3,1
    191e:	0ec77863          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    1922:	000780a3          	sb	zero,1(a5)
    1926:	0026871b          	addiw	a4,a3,2
    192a:	0ec77263          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    192e:	00078123          	sb	zero,2(a5)
    1932:	0036871b          	addiw	a4,a3,3
    1936:	0cc77c63          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    193a:	000781a3          	sb	zero,3(a5)
    193e:	0046871b          	addiw	a4,a3,4
    1942:	0cc77663          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    1946:	00078223          	sb	zero,4(a5)
    194a:	0056871b          	addiw	a4,a3,5
    194e:	0cc77063          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    1952:	000782a3          	sb	zero,5(a5)
    1956:	0066871b          	addiw	a4,a3,6
    195a:	0ac77a63          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    195e:	00078323          	sb	zero,6(a5)
    1962:	0076871b          	addiw	a4,a3,7
    1966:	0ac77463          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    196a:	000783a3          	sb	zero,7(a5)
    196e:	0086871b          	addiw	a4,a3,8
    1972:	08c77e63          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    1976:	00078423          	sb	zero,8(a5)
    197a:	0096871b          	addiw	a4,a3,9
    197e:	08c77863          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    1982:	000784a3          	sb	zero,9(a5)
    1986:	00a6871b          	addiw	a4,a3,10
    198a:	08c77263          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    198e:	00078523          	sb	zero,10(a5)
    1992:	00b6871b          	addiw	a4,a3,11
    1996:	06c77c63          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    199a:	000785a3          	sb	zero,11(a5)
    199e:	00c6871b          	addiw	a4,a3,12
    19a2:	06c77663          	bgeu	a4,a2,1a0e <stpncpy+0x1ce>
    19a6:	00078623          	sb	zero,12(a5)
    19aa:	26b5                	addiw	a3,a3,13
    19ac:	06c6f163          	bgeu	a3,a2,1a0e <stpncpy+0x1ce>
    19b0:	000786a3          	sb	zero,13(a5)
    19b4:	8082                	ret
            ;
        if (!n || !*s)
    19b6:	c645                	beqz	a2,1a5e <stpncpy+0x21e>
    19b8:	0005c783          	lbu	a5,0(a1)
    19bc:	ea078be3          	beqz	a5,1872 <stpncpy+0x32>
            goto tail;
        wd = (void*)d;
        ws = (const void*)s;
        for (; n >= sizeof(size_t) && !HASZERO(*ws); n -= sizeof(size_t), ws++, wd++)
    19c0:	479d                	li	a5,7
    19c2:	02c7ff63          	bgeu	a5,a2,1a00 <stpncpy+0x1c0>
    19c6:	00000897          	auipc	a7,0x0
    19ca:	27a8b883          	ld	a7,634(a7) # 1c40 <MAX_CHILD+0x10>
    19ce:	00000817          	auipc	a6,0x0
    19d2:	27a83803          	ld	a6,634(a6) # 1c48 <MAX_CHILD+0x18>
    19d6:	431d                	li	t1,7
    19d8:	6198                	ld	a4,0(a1)
    19da:	011707b3          	add	a5,a4,a7
    19de:	fff74693          	not	a3,a4
    19e2:	8ff5                	and	a5,a5,a3
    19e4:	0107f7b3          	and	a5,a5,a6
    19e8:	ef81                	bnez	a5,1a00 <stpncpy+0x1c0>
            *wd = *ws;
    19ea:	e118                	sd	a4,0(a0)
        for (; n >= sizeof(size_t) && !HASZERO(*ws); n -= sizeof(size_t), ws++, wd++)
    19ec:	1661                	addi	a2,a2,-8
    19ee:	05a1                	addi	a1,a1,8
    19f0:	0521                	addi	a0,a0,8
    19f2:	fec363e3          	bltu	t1,a2,19d8 <stpncpy+0x198>
        d = (void*)wd;
        s = (const void*)ws;
    }
    for (; n && (*d = *s); n--, s++, d++)
    19f6:	e609                	bnez	a2,1a00 <stpncpy+0x1c0>
    19f8:	a08d                	j	1a5a <stpncpy+0x21a>
    19fa:	167d                	addi	a2,a2,-1
    19fc:	0505                	addi	a0,a0,1
    19fe:	ca01                	beqz	a2,1a0e <stpncpy+0x1ce>
    1a00:	0005c783          	lbu	a5,0(a1)
    1a04:	0585                	addi	a1,a1,1
    1a06:	00f50023          	sb	a5,0(a0)
    1a0a:	fbe5                	bnez	a5,19fa <stpncpy+0x1ba>
        ;
tail:
    1a0c:	b59d                	j	1872 <stpncpy+0x32>
    memset(d, 0, n);
    return d;
    1a0e:	8082                	ret
    1a10:	472d                	li	a4,11
    1a12:	bdb5                	j	188e <stpncpy+0x4e>
    1a14:	00778713          	addi	a4,a5,7
    1a18:	45ad                	li	a1,11
    1a1a:	fff60693          	addi	a3,a2,-1
    1a1e:	e6b778e3          	bgeu	a4,a1,188e <stpncpy+0x4e>
    1a22:	b7fd                	j	1a10 <stpncpy+0x1d0>
    1a24:	40a007b3          	neg	a5,a0
    1a28:	8832                	mv	a6,a2
    1a2a:	8b9d                	andi	a5,a5,7
    1a2c:	4681                	li	a3,0
    1a2e:	e4060be3          	beqz	a2,1884 <stpncpy+0x44>
    1a32:	b7cd                	j	1a14 <stpncpy+0x1d4>
    for(int i = 0; i < n; ++i, *(p++) = c);
    1a34:	468d                	li	a3,3
    1a36:	bd75                	j	18f2 <stpncpy+0xb2>
    1a38:	872a                	mv	a4,a0
    1a3a:	4681                	li	a3,0
    1a3c:	bd5d                	j	18f2 <stpncpy+0xb2>
    1a3e:	4685                	li	a3,1
    1a40:	bd4d                	j	18f2 <stpncpy+0xb2>
    1a42:	8082                	ret
    1a44:	87aa                	mv	a5,a0
    1a46:	4681                	li	a3,0
    1a48:	b5f9                	j	1916 <stpncpy+0xd6>
    1a4a:	4689                	li	a3,2
    1a4c:	b55d                	j	18f2 <stpncpy+0xb2>
    1a4e:	4691                	li	a3,4
    1a50:	b54d                	j	18f2 <stpncpy+0xb2>
    1a52:	4695                	li	a3,5
    1a54:	bd79                	j	18f2 <stpncpy+0xb2>
    1a56:	4699                	li	a3,6
    1a58:	bd69                	j	18f2 <stpncpy+0xb2>
    1a5a:	8082                	ret
    1a5c:	8082                	ret
    1a5e:	8082                	ret

0000000000001a60 <open>:
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
}

static inline long __syscall3(long n, long a, long b, long c)
{
    register long a7 __asm__("a7") = n;
    1a60:	03800893          	li	a7,56
    register long a0 __asm__("a0") = a;
    register long a1 __asm__("a1") = b;
    register long a2 __asm__("a2") = c;
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1a64:	00000073          	ecall

#include "syscall.h"

int open(const char *path, int flags, int mode) {
    return syscall(SYS_openat, path, flags, mode);
}
    1a68:	2501                	sext.w	a0,a0
    1a6a:	8082                	ret

0000000000001a6c <close>:
    register long a7 __asm__("a7") = n;
    1a6c:	03900893          	li	a7,57
    __asm_syscall("r"(a7), "0"(a0))
    1a70:	00000073          	ecall

int close(int fd) {
    return syscall(SYS_close, fd);
}
    1a74:	2501                	sext.w	a0,a0
    1a76:	8082                	ret

0000000000001a78 <read>:
    register long a7 __asm__("a7") = n;
    1a78:	03f00893          	li	a7,63
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1a7c:	00000073          	ecall

ssize_t read(int fd, void *buf, unsigned long long len) {
    return syscall(SYS_read, fd, buf, len);
}
    1a80:	8082                	ret

0000000000001a82 <write>:
    register long a7 __asm__("a7") = n;
    1a82:	04000893          	li	a7,64
    __asm_syscall("r"(a7), "0"(a0), "r"(a1), "r"(a2))
    1a86:	00000073          	ecall

ssize_t write(int fd, const void *buf, unsigned long long len) {
    return syscall(SYS_write, fd, buf, len);
}
    1a8a:	8082                	ret

0000000000001a8c <getpid>:
    register long a7 __asm__("a7") = n;
    1a8c:	0ac00893          	li	a7,172
    __asm_syscall("r"(a7))
    1a90:	00000073          	ecall

int getpid(void) {
    return syscall(SYS_getpid);
}
    1a94:	2501                	sext.w	a0,a0
    1a96:	8082                	ret

0000000000001a98 <sched_yield>:
    register long a7 __asm__("a7") = n;
    1a98:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1a9c:	00000073          	ecall

int sched_yield(void) {
    return syscall(SYS_sched_yield);
}
    1aa0:	2501                	sext.w	a0,a0
    1aa2:	8082                	ret

0000000000001aa4 <fork>:
    register long a7 __asm__("a7") = n;
    1aa4:	0dc00893          	li	a7,220
    __asm_syscall("r"(a7))
    1aa8:	00000073          	ecall

int fork(void) {
    return syscall(SYS_clone);
}
    1aac:	2501                	sext.w	a0,a0
    1aae:	8082                	ret

0000000000001ab0 <exit>:
    register long a7 __asm__("a7") = n;
    1ab0:	05d00893          	li	a7,93
    __asm_syscall("r"(a7), "0"(a0))
    1ab4:	00000073          	ecall

void exit(int code) {
    syscall(SYS_exit, code);
}
    1ab8:	8082                	ret

0000000000001aba <wait>:
    register long a7 __asm__("a7") = n;
    1aba:	10400893          	li	a7,260
    __asm_syscall("r"(a7), "0"(a0), "r"(a1))
    1abe:	00000073          	ecall

int wait(int pid, int* code) {
    return syscall(SYS_wait4, pid, code);
}
    1ac2:	2501                	sext.w	a0,a0
    1ac4:	8082                	ret

0000000000001ac6 <exec>:
    register long a7 __asm__("a7") = n;
    1ac6:	0dd00893          	li	a7,221
    __asm_syscall("r"(a7), "0"(a0))
    1aca:	00000073          	ecall

int exec(char* name) {
    return syscall(SYS_execve, name);
}
    1ace:	2501                	sext.w	a0,a0
    1ad0:	8082                	ret

0000000000001ad2 <get_time>:
    register long a7 __asm__("a7") = n;
    1ad2:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1ad6:	00000073          	ecall

uint64 get_time() {
    return syscall(SYS_times);
}
    1ada:	8082                	ret

0000000000001adc <sleep>:

int sleep(unsigned long long time) {
    1adc:	872a                	mv	a4,a0
    register long a7 __asm__("a7") = n;
    1ade:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1ae2:	00000073          	ecall
    1ae6:	87aa                	mv	a5,a0
    1ae8:	00000073          	ecall
    unsigned long long s = get_time();
    while(get_time() < s + time) {
    1aec:	97ba                	add	a5,a5,a4
    1aee:	00f57c63          	bgeu	a0,a5,1b06 <sleep+0x2a>
    register long a7 __asm__("a7") = n;
    1af2:	07c00893          	li	a7,124
    __asm_syscall("r"(a7))
    1af6:	00000073          	ecall
    register long a7 __asm__("a7") = n;
    1afa:	09900893          	li	a7,153
    __asm_syscall("r"(a7))
    1afe:	00000073          	ecall
    1b02:	fef568e3          	bltu	a0,a5,1af2 <sleep+0x16>
        sched_yield();
    }
    return 0;
}
    1b06:	4501                	li	a0,0
    1b08:	8082                	ret

0000000000001b0a <pipe>:
    register long a7 __asm__("a7") = n;
    1b0a:	03b00893          	li	a7,59
    __asm_syscall("r"(a7), "0"(a0))
    1b0e:	00000073          	ecall

int pipe(void* p) {
    return syscall(SYS_pipe2, p);
    1b12:	2501                	sext.w	a0,a0
    1b14:	8082                	ret

Disassembly of section .text.startup:

0000000000001b16 <main>:
#include <stdlib.h>
#include <unistd.h>

const int MAX_CHILD = 40;

int main() {
    1b16:	7139                	addi	sp,sp,-64
    1b18:	f822                	sd	s0,48(sp)
    1b1a:	f426                	sd	s1,40(sp)
    1b1c:	f04a                	sd	s2,32(sp)
    1b1e:	ec4e                	sd	s3,24(sp)
    1b20:	fc06                	sd	ra,56(sp)
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b22:	4401                	li	s0,0
        int pid = fork();
        if (pid == 0) {
            printf("I am child %d\n", i);
            exit(0);
        } else {
            printf("forked child pid = %d\n", pid);
    1b24:	00000997          	auipc	s3,0x0
    1b28:	0ac98993          	addi	s3,s3,172 # 1bd0 <main+0xba>
            printf("I am child %d\n", i);
    1b2c:	00000917          	auipc	s2,0x0
    1b30:	09490913          	addi	s2,s2,148 # 1bc0 <main+0xaa>
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b34:	02800493          	li	s1,40
    1b38:	a809                	j	1b4a <main+0x34>
            printf("I am child %d\n", i);
    1b3a:	d66ff0ef          	jal	ra,10a0 <printf>
            exit(0);
    1b3e:	4501                	li	a0,0
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b40:	2405                	addiw	s0,s0,1
            exit(0);
    1b42:	f6fff0ef          	jal	ra,1ab0 <exit>
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b46:	00940f63          	beq	s0,s1,1b64 <main+0x4e>
        int pid = fork();
    1b4a:	f5bff0ef          	jal	ra,1aa4 <fork>
    1b4e:	87aa                	mv	a5,a0
            printf("I am child %d\n", i);
    1b50:	85a2                	mv	a1,s0
    1b52:	854a                	mv	a0,s2
        if (pid == 0) {
    1b54:	d3fd                	beqz	a5,1b3a <main+0x24>
            printf("forked child pid = %d\n", pid);
    1b56:	85be                	mv	a1,a5
    1b58:	854e                	mv	a0,s3
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b5a:	2405                	addiw	s0,s0,1
            printf("forked child pid = %d\n", pid);
    1b5c:	d44ff0ef          	jal	ra,10a0 <printf>
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b60:	fe9415e3          	bne	s0,s1,1b4a <main+0x34>
        }
    }

    int exit_code = 0;
    1b64:	c602                	sw	zero,12(sp)
    1b66:	02800413          	li	s0,40
    for (int i = 0; i < MAX_CHILD; ++i) {
        if (wait(-1, &exit_code) <= 0) {
            panic("wait stopped early");
    1b6a:	00000497          	auipc	s1,0x0
    1b6e:	07e48493          	addi	s1,s1,126 # 1be8 <main+0xd2>
        if (wait(-1, &exit_code) <= 0) {
    1b72:	006c                	addi	a1,sp,12
    1b74:	557d                	li	a0,-1
    1b76:	f45ff0ef          	jal	ra,1aba <wait>
    1b7a:	347d                	addiw	s0,s0,-1
    1b7c:	02a05d63          	blez	a0,1bb6 <main+0xa0>
    for (int i = 0; i < MAX_CHILD; ++i) {
    1b80:	f86d                	bnez	s0,1b72 <main+0x5c>
        }
    }
    if (wait(-1, &exit_code) > 0) {
    1b82:	006c                	addi	a1,sp,12
    1b84:	557d                	li	a0,-1
    1b86:	f35ff0ef          	jal	ra,1aba <wait>
    1b8a:	00a05863          	blez	a0,1b9a <main+0x84>
        panic("wait got too many");
    1b8e:	00000517          	auipc	a0,0x0
    1b92:	07250513          	addi	a0,a0,114 # 1c00 <main+0xea>
    1b96:	83bff0ef          	jal	ra,13d0 <panic>
    }
    printf("forktest pass.\n");
    1b9a:	00000517          	auipc	a0,0x0
    1b9e:	07e50513          	addi	a0,a0,126 # 1c18 <main+0x102>
    1ba2:	cfeff0ef          	jal	ra,10a0 <printf>
    return 0;
    1ba6:	70e2                	ld	ra,56(sp)
    1ba8:	7442                	ld	s0,48(sp)
    1baa:	74a2                	ld	s1,40(sp)
    1bac:	7902                	ld	s2,32(sp)
    1bae:	69e2                	ld	s3,24(sp)
    1bb0:	4501                	li	a0,0
    1bb2:	6121                	addi	sp,sp,64
    1bb4:	8082                	ret
            panic("wait stopped early");
    1bb6:	8526                	mv	a0,s1
    1bb8:	819ff0ef          	jal	ra,13d0 <panic>
    for (int i = 0; i < MAX_CHILD; ++i) {
    1bbc:	f85d                	bnez	s0,1b72 <main+0x5c>
    1bbe:	b7d1                	j	1b82 <main+0x6c>
