TriOsc s => dac;

[48, 60] @=> int keys[];
0 => int idx;
keys[idx] => int key;

fun void play (int midiNote, float time) {
	Math.mtof(midiNote) => s.freq;
	time::second => now;
}

while (true) {

	play(key + 2, 0.2);
	play(0, 0.1);

	play(key + 5, 0.4);
	play(0, 0.2);

	play(key + 0, 0.2);
	play(0, 0.1);

	play(key + 5, 0.4);
	play(0, 0.6);

	idx + 1 => idx;
	keys[idx%2] => key;
}