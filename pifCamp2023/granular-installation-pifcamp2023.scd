Server.default.options.numOutputBusChannels = 10;
s.boot;
//------------------------------------------------------------------------
(
~voice = Buffer.read(s,"/home/gat/documents/pifcamp-2023/sc-code/samples/zapotec0-short.out.wav");
~k = Buffer.read(s,"/home/gat/documents/pifcamp-2023/sc-code/samples/KickAkd11.out.wav");
~brush = Buffer.read(s,"/home/gat/documents/pifcamp-2023/sc-code/samples/brush-loop.out.wav")
)
//------------------------------------------------------------------------
(
~help = {
	" ".postln;
	"numChannels".postln;
	"trigger".postln;
    "bufnum".postln;
    "rate".postln;
    "center".postln;
    "dur".postln;
    "pan".postln;
    "amp".postln;
    "interp".postln;
	" ".postln;
}
)
//------------------------------------------------------------------------
(
Ndef(\v, {
	var sig, env, trigger, dur;
	trigger = 11; dur = 3;
	sig = TGrains.ar(2,Impulse.ar(trigger),~voice.bufnum,SinOsc.kr(0.01).range(0.1,0.2),30,dur, 0, SinOsc.kr(0.02).range(0,0.3));// * Dust.ar(5000, 0.5);
	sig = FreeVerb.ar(sig,SinOsc.kr(1).range(0.55,0.6),SinOsc.kr(3).range(0,1,3),SinOsc.kr(2));
	sig = Resonz.ar(sig,SinOsc.kr(0.01).range(60,206),SinOsc.kr(0.1).range(0.2,0.7));
	sig = sig * 15;
    });
Ndef(\k, {
	var sig, env, trigger, dur;
	trigger = 4; dur = 0.3;
	sig = TGrains.ar(2, Impulse.ar(trigger),~k.bufnum, 0.7, 0.1, dur, 0, SinOsc.kr(0.01).range(0,0.2)) + Impulse.ar(22,0,0.1);
	sig = FreeVerb.ar(sig,SinOsc.kr(1).range(0.55,0.8),SinOsc.kr(1));
	sig = CompanderD.ar(sig,SinOsc.kr(0.01).range(0.1,0.7))
    });
Ndef(\b, {
	var sig, env, trigger, dur;
	trigger = 3; dur = 2;
	sig = TGrains.ar(2, Impulse.ar(trigger),~brush.bufnum, SinOsc.kr(0.01).range(0.5, 0.6), 0.1, dur, 0, SinOsc.kr(0.01).range(0.3,0.9));
	sig = HPF.ar(sig,1500,1,0.5);
	sig = CompanderD.ar(sig)
});
);
// multichannel
//------------------------------------------------------------------------
~br = { | o = 1, p = 4 |(o / p * (0..p - 1)).floor.differentiate.asInteger.put(0, 1);};
(
	~channels = {
		|i|
		var out = [];
		var array = ~br.value(i,10);
		array.do{|x,i| 
		//x.postln;i.postln;
		if(x==1){out = out.add(i)}};
		out.postln;
		out;
}
)
//~channels.value(10)
//------------------------------------------------------------------------
(
Ndef(\v).fadeTime = 7;
Ndef(\k).fadeTime = 7;
Ndef(\b).fadeTime = 3;
)
(
	Ndef(\v).play([1,2,3]);
	Ndef(\k).play([0]);
	Ndef(\b).play([4,5,6,7,8,9]);
)
//------------------------------------------------------------------------
(
	Tdef(\installation,{
		10.do{
			1.do{
				var i = rrand(0,10);
				var array =  ~channels.value(i);
				Ndef(\v).play(array);
			};
			[30,20,10].choose.wait;
			1.do{ 
				var i = rrand(0,10);
				var array =  ~channels.value(i);
				Ndef(\k).play(array);
			};
			[10,20,30].choose.wait;
			1.do{
				var i = rrand(0,10);
				var array =  ~channels.value(i);
				Ndef(\b).play(array);
			};
			[10,20,40].choose.wait;
}
}).play
)
s.meter


Ndef.clear.all(10)
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////
Ndef(\clean).fadeTime = 2;
Ndef(\clean).set(\amp,0)
Ndef(\clean).stop//set(\amp,0)
(
	Ndef(\clean,{
		arg amp = 0.06;
		Dust.ar(40000,amp)
	}).playN([9])
)

Ndef.clear.all
