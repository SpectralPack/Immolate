// RNG Cache
typedef enum RandomType {
    R_Joker_Common,
    R_Joker_Uncommon,
    R_Joker_Rare,
    R_Joker_Legendary,
    R_Joker_Rarity,
    R_Joker_Edition,
    R_Misprint,
    R_Standard_Has_Enhancement,
    R_Enhancement,
    R_Card,
    R_Standard_Edition,
    R_Standard_Has_Seal,
    R_Standard_Seal,
    R_Shop_Pack,
    R_Tarot,
    R_Spectral,
    R_Tags,
    R_Shuffle_New_Round,
    R_Card_Type,
    R_Planet,
    R_Lucky_Mult,
    R_Lucky_Money,
    R_Sigil,
    R_Ouija,
    R_Wheel_of_Fortune,
    R_Gros_Michel,
    R_Cavendish,
    R_Voucher,
    R_Voucher_Tag,
    R_Orbital_Tag,
    R_Soul,
    R_Erratic,
    R_Eternal,
    R_Perishable,
    R_Eternal_Perishable,
    R_Eternal_Perishable_Pack,
    R_Rental,
    R_Rental_Pack,
    R_Boss,
    R_END
} rtype;

typedef enum RNGSource {
    S_Shop,
    S_Emperor,
    S_High_Priestess,
    S_Judgement,
    S_Wraith,
    S_Arcana,
    S_Celestial,
    S_Spectral,
    S_Standard,
    S_Buffoon,
    S_Vagabond,
    S_Superposition,
    S_Seance,
    S_Sixth_Sense,
    S_Top_Up,
    S_Rare_Tag,
    S_Uncommon_Tag,
    S_Blue_Seal,
    S_Purple_Seal,
    S_8_Ball,
    S_Soul,
    S_Riff_Raff,
    S_Cartomancer,
    S_Null,
    SOURCE_END
} rsrc;

typedef enum NodeType {
    N_Type,
    N_Source,
    N_Ante,
    N_Resample
} ntype;

// String values for each node
void type_str(text *t, int x) {
    switch(x) {
        case R_Joker_Common:             append_or_init_text(t,"Joker1", 6); return;
        case R_Joker_Uncommon:           append_or_init_text(t,"Joker2", 6); return;
        case R_Joker_Rare:               append_or_init_text(t,"Joker3", 6); return;
        case R_Joker_Legendary:          append_or_init_text(t,"Joker4", 6); return;
        case R_Joker_Rarity:             append_or_init_text(t,"rarity", 6); return;
        case R_Joker_Edition:            append_or_init_text(t,"edi", 3); return;
        case R_Misprint:                 append_or_init_text(t,"misprint", 8); return;
        case R_Standard_Has_Enhancement: append_or_init_text(t,"stdset", 6); return;
        case R_Enhancement:              append_or_init_text(t,"Enhanced", 8); return;
        case R_Card:                     append_or_init_text(t,"front", 5); return;
        case R_Standard_Edition:         append_or_init_text(t,"standard_edition", 16); return;
        case R_Standard_Has_Seal:        append_or_init_text(t,"stdseal", 7); return;
        case R_Standard_Seal:            append_or_init_text(t,"stdsealtype", 11); return;
        case R_Shop_Pack:                append_or_init_text(t,"shop_pack", 9); return;
        case R_Tarot:                    append_or_init_text(t,"Tarot", 5); return;
        case R_Spectral:                 append_or_init_text(t,"Spectral", 8); return;
        case R_Tags:                     append_or_init_text(t,"Tag", 3); return;
        case R_Shuffle_New_Round:        append_or_init_text(t,"nr", 2); return;
        case R_Card_Type:                append_or_init_text(t,"cdt", 3); return;
        case R_Planet:                   append_or_init_text(t,"Planet", 6); return;
        case R_Lucky_Mult:               append_or_init_text(t,"lucky_mult", 10); return;
        case R_Lucky_Money:              append_or_init_text(t,"lucky_money", 11); return;
        case R_Sigil:                    append_or_init_text(t,"sigil", 5); return;
        case R_Ouija:                    append_or_init_text(t,"ouija", 5); return;
        case R_Wheel_of_Fortune:         append_or_init_text(t,"wheel_of_fortune", 16); return;
        case R_Gros_Michel:              append_or_init_text(t,"gros_michel", 11); return;
        case R_Cavendish:                append_or_init_text(t,"cavendish", 9); return;
        case R_Voucher:                  append_or_init_text(t,"Voucher", 7); return;
        case R_Voucher_Tag:              append_or_init_text(t,"Voucher_fromtag", 15); return;
        case R_Orbital_Tag:              append_or_init_text(t,"orbital", 7); return;
        case R_Soul:                     append_or_init_text(t,"soul_", 5); return;
        case R_Erratic:                  append_or_init_text(t,"erratic", 7); return;
        case R_Eternal:                  append_or_init_text(t,"stake_shop_joker_eternal", 24); return;
        case R_Perishable:               append_or_init_text(t,"ssjp", 4); return;
        case R_Rental:                   append_or_init_text(t,"ssjr", 4); return;
        case R_Eternal_Perishable:       append_or_init_text(t,"etperpoll", 9); return;
        case R_Rental_Pack:              append_or_init_text(t,"packssjr", 8); return;
        case R_Eternal_Perishable_Pack:  append_or_init_text(t,"packetper", 9); return;
        case R_Boss:                     append_or_init_text(t,"boss", 4); return;
        default:                         append_or_init_text(t,"", 0); return;
    }
}
void source_str(text *t, int x) {
    switch(x) {
        case S_Shop:           append_or_init_text(t,"sho", 3); return;
        case S_Emperor:        append_or_init_text(t,"emp", 3); return;
        case S_High_Priestess: append_or_init_text(t,"pri", 3); return;
        case S_Judgement:      append_or_init_text(t,"jud", 3); return;
        case S_Wraith:         append_or_init_text(t,"wra", 3); return;
        case S_Arcana:         append_or_init_text(t,"ar1", 3); return;
        case S_Celestial:      append_or_init_text(t,"pl1", 3); return;
        case S_Spectral:       append_or_init_text(t,"spe", 3); return;
        case S_Standard:       append_or_init_text(t,"sta", 3); return;
        case S_Buffoon:        append_or_init_text(t,"buf", 3); return;
        case S_Vagabond:       append_or_init_text(t,"vag", 3); return;
        case S_Superposition:  append_or_init_text(t,"sup", 3); return;
        case S_8_Ball:         append_or_init_text(t,"8ba", 3); return;
        case S_Seance:         append_or_init_text(t,"sea", 3); return;
        case S_Sixth_Sense:    append_or_init_text(t,"sixth", 5); return;
        case S_Top_Up:         append_or_init_text(t,"top", 3); return;
        case S_Rare_Tag:       append_or_init_text(t,"rta", 3); return;
        case S_Uncommon_Tag:   append_or_init_text(t,"uta", 3); return;
        case S_Blue_Seal:      append_or_init_text(t,"blusl", 5); return;
        case S_Purple_Seal:    append_or_init_text(t,"8ba", 3); return;
        case S_Soul:           append_or_init_text(t,"sou", 3); return;
        case S_Riff_Raff:      append_or_init_text(t,"rif", 3); return;
        case S_Cartomancer:    append_or_init_text(t,"car", 3); return;
        default:               append_or_init_text(t,"", 0); return;
    }
}
void resample_str(text* t, int x) {
    if (x == 0) return;
    append_or_init_text(t,"_resample", 9);
    int_to_str(t,x+1);
}

typedef struct RNGInfo {
    ntype nodeTypes[4];
    int nodeValues[4];
    int depth;
    double rngState;
} rnginfo;

typedef struct Cache {
    #ifdef CACHE_SIZE
    rnginfo nodes[CACHE_SIZE];
    #else
    rnginfo nodes[64];
    #endif
    bool generatedFirstPack;
    int nextFreeNode;
} cache;

void node_str(text* t, ntype nt, int x) {
    switch (nt) {
        case N_Type: type_str(t,x); return;
        case N_Source: source_str(t,x); return;
        case N_Ante: int_to_str(t,x); return;
        case N_Resample: resample_str(t,x); return;
    }
}
int init_node(cache* c, ntype nodeTypes[], int nodeValues[], int depth) {
    for (int i = 0; i < depth; i++) {
        c->nodes[c->nextFreeNode].nodeTypes[i] = nodeTypes[i];
        c->nodes[c->nextFreeNode].nodeValues[i] = nodeValues[i];
    }
    c->nodes[c->nextFreeNode].depth = depth;
    c->nextFreeNode++;
    return c->nextFreeNode-1;
};