template GreaterThan(n) {
    signal input in1;
    signal input in2;
    signal output out;

    component isGT = LessThan(n);
    isGT.in1 <== in2;
    isGT.in2 <== in1;
    out <== 1 - isGT.out;
}

template LessThan(n) {
    signal input in1;
    signal input in2;
    signal output out;

    var i;

    component bits1[n];
    component bits2[n];
    signal tmp[n];

    for (i = 0; i < n; i++) {
        bits1[i] = Num2Bits(1);
        bits2[i] = Num2Bits(1);

        bits1[i].in <== in1 >> i & 1;
        bits2[i].in <== in2 >> i & 1;
    }

    tmp[n - 1] <== 0;
    for (i = n - 1; i >= 0; i--) {
        tmp[i] <== (bits1[i].out < bits2[i].out) ? 1 : (bits1[i].out == bits2[i].out) ? tmp[i + 1] : 0;
    }
    out <== tmp[0];
}

template AgeVerification() {
    signal input birthdate;
    signal input currentDate;
    signal output isOver18;

    signal ageInSeconds;
    signal threshold;

    threshold <== 18 * 365 * 24 * 60 * 60;
    ageInSeconds <== currentDate - birthdate;

    component compare = GreaterThan(64);
    compare.in1 <== ageInSeconds;
    compare.in2 <== threshold;
    isOver18 <== compare.out;
}

component main = AgeVerification();
