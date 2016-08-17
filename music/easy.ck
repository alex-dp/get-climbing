TriOsc s => dac;

[48, 60] @=> int keys[];
0 => int idx;
keys[idx] => int key;

while (true) {

	Math.mtof(key + 2) => s.freq;
	0.2::second => now;
	0 => s.freq;
	0.10::second => now;

	Math.mtof(key + 5) => s.freq;
	0.4::second => now;
	0 => s.freq;
	0.2::second => now;

	Math.mtof(key + 0) => s.freq;
	0.2::second => now;
	0 => s.freq;
	0.10::second => now;

	Math.mtof(key + 5) => s.freq;
	0.4::second => now;
	0 => s.freq;
	0.6::second => now;

	idx + 1 => idx;
	keys[idx%2] => key;
}