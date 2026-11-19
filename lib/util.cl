#define TEXT_LENGTH 64
#define PI_VALUE 3.141592653589793116
#define HASH_CONSTANT 1.1239285023
// Pseudohash
typedef struct Text {
    char str[TEXT_LENGTH];
    int len;
} text;

inline text t_new() {
    text t;
    t.len = 0;
    return t;
}

inline void init_text(text* t, __constant char* str, int len) {
    for (int i = 0; i < len; i++){
        t->str[i] = str[i];
    }
    t->len = len;
    t->str[t->len] = '\0';
    return;
}
inline void set_text_length(text* t, int len) {
    t->len = len;
    t->str[t->len] = '\0';
}

inline void append_or_init_text(text* t, __constant char* str, int len) {
    for (int j = 0; j < len; j++) {
        t->str[t->len+j] = str[j];
    }
    set_text_length(t, t->len+len);
}

inline void text_concat(text* a, text* b) {
    for (int j = 0; j < b->len; j++) {
        a->str[a->len+j] = b->str[j];
    }
    set_text_length(a, a->len+b->len);
}

void print_text(text* x) {
    for (int i = 0; i < x->len; i++) {
        printf("%c",x->str[i]);
    }
    printf("\n");
}

double fract(double f) {
    return f-floor(f);
}

double pseudohash(text* s) {
    double num = 1;
    for (int i = s->len - 1; i >= 0; i--) {
        // With OPENCL FP_CONTRACT OFF, we can use the original formula
        num = fract(HASH_CONSTANT/num*s->str[i]*PI_VALUE+PI_VALUE*(i+1));
    }
    return num;
}

double pseudohash_skip_length(text* s, int length) {
    // length give the length of what will be hashed
    // and allows us to has the first part for caching
    double num = 1;
    for (int i = s->len - 1; i >= 0; i--) {
        // With OPENCL FP_CONTRACT OFF, we can use the original formula
        num = fract(HASH_CONSTANT/num*s->str[i]*PI_VALUE+PI_VALUE*(length+i+1));
    }
    return num;
}

double pseudohash_skip_seed(text* s, double num) {
    for (int i = s->len - 1; i >= 0; i--) {
        // With OPENCL FP_CONTRACT OFF, we can use the original formula
        num = fract(HASH_CONSTANT/num*s->str[i]*PI_VALUE+PI_VALUE*(i+1));
    }
    return num;
}

double pseudohash8(char8 s) {
    //resizeString(&s, 16, ' ');
    double num = 1;
    int k = 32;
    for (int i = 7; i >= 0; i--) {
        long int_part = (HASH_CONSTANT/num*s[i]*PI_VALUE+PI_VALUE*(i+1))*(1<<k);
        double fract_part = fract(fract((HASH_CONSTANT/num*s[i]*PI_VALUE)*(1<<k))+fract((PI_VALUE*(i+1))*(1<<k)));
        num = fract(((double)(int_part)+fract_part)/(1<<k));
    }
    return num;
}

// Pseudohash Legacy
unsigned int lsh32(unsigned int x, size_t l) {
    return x<<l;
}
unsigned int rsh32(unsigned int x, size_t r) {
    return x>>r;
}
double roundDigits(double f) {
    return round(f * 1e13) / 1e13;
}

double pseudohash_legacy(__constant char* s, size_t stringLen) {
    //resizeString(&s, 16, ' ');
    int mask = 0;
    if (stringLen >= 16) {
        // Use first 16 chars
        for (int i = 15; i >= 0; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
        }
    } else {
        // Use space (32) for empty chars
        for (int i = 15; i >= stringLen; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+32);
        }
        for (int i = stringLen-1; i >= 0; i--) {
            mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
        }
    }
    return roundDigits(fract(sqrt((double)(abs(mask)))));
}

double c16_pseudohash_legacy(char16 s) {
    //resizeString(&s, 16, ' ');
    int mask = 0;
    for (int i = 15; i >= 0; i--) {
        mask = mask^(lsh32(mask,7)+rsh32(mask,3)+s[i]);
    }
    return roundDigits(fract(sqrt((double)(abs(mask)))));
}

char16 c8_as_c16(char8 c8) {
    char16 c16 = ' ';
    for (int i = 0; i < 8; i++) {
        c16[i] = c8[i];
    }
    return c16;
}

// math.random

typedef union DoubleLong {
    double d;
    ulong ul;
} dbllong;

typedef struct LuaRandom {
    ulong4 state;
    dbllong out;
} lrandom;

void _randint(lrandom* lr) {
    ulong z, r = 0;
    z = lr->state[0];
    z = (((z<<31)^z)>>45)^((z&((ulong)(long)-1<<1))<<18);
    r ^= z;
    lr->state[0] = z;
    z = lr->state[1];
    z = (((z<<19)^z)>>30)^((z&((ulong)(long)-1<<6))<<28);
    r ^= z;
    lr->state[1] = z;
    z = lr->state[2];
    z = (((z<<24)^z)>>48)^((z&((ulong)(long)-1<<9))<<7);
    r ^= z;
    lr->state[2] = z;
    z = lr->state[3];
    z = (((z<<21)^z)>>39)^((z&((ulong)(long)-1<<17))<<8);
    r ^= z;
    lr->state[3] = z;
    lr->out.ul = r;
}

void randdblmem(lrandom* lr) {
    _randint(lr);
    lr->out.ul = (lr->out.ul&4503599627370495)|4607182418800017408;
}

lrandom randomseed(double d) {
    lrandom lr;
    uint r = 0x11090601;
    size_t i;
    for (i = 0; i < 4; i++) {
        ulong u;
        uint m = 1 << (r&255);
        r >>= 8;
        // Doing these two operations separately fixes the code for some reason...
        // Probably another roundoff issue...
        d = d*3.14159265358979323846;
        d = d+2.7182818284590452354;
        lr.out.d = d;
        u = lr.out.ul;
        if (u<m) u+=m;
        lr.state[i] = u;
    }
    for (i = 0; i < 10; i++) {
        _randint(&lr);
    }
    return lr;
}
double l_random(lrandom* lr) {
    randdblmem(lr);
    lr->out.d -= 1.0;
    return lr->out.d;
}
ulong l_randint(lrandom* lr, ulong min, ulong max) {
    l_random(lr);
    return (ulong)(lr->out.d*(max-min+1))+min;
}

//Misc utility stuff
void int_to_str(text* t, int x) {
    // Get length
    int temp = x;
    int digits = 1;
    while (temp / 10 > 0) {
        digits++;
        temp /= 10;
    }
    for (int i = digits-1; i >= 0; i--) {
        t->str[t->len+i] = '0' + x%10;
        x/=10;
    }
    t->len = t->len + digits;
    return;
}

#define V_AT_LEAST(v1,v2,v3,v4) \
        (VER1 > v1) || \
        (VER1 == v1 && ((VER2 > v2) ||\
        (VER2 == v2 && ((VER3 > v3) ||\
        (VER3 == v3 && VER4 >= v4)))))

#define V_AT_MOST(v1,v2,v3,v4) \
        (VER1 < v1) || \
        (VER1 == v1 && ((VER2 < v2) ||\
        (VER2 == v2 && ((VER3 < v3) ||\
        (VER3 == v3 && VER4 <= v4)))))

// Define some constants for important game version splits
#if V_AT_MOST(0,9999,9999,9999)
    #define DEMO
#endif