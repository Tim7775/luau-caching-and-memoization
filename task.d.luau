declare task: {
	cancel: (thread: thread) -> (),
	defer: <A..., R...>(f: thread | ((A...) -> R...), A...) -> thread,
	spawn: <A..., R...>(f: thread | ((A...) -> R...), A...) -> thread,
	delay: <A..., R...>(sec: number?, f: thread | ((A...) -> R...), A...) -> thread,
	wait: (sec: number?) -> number,
	synchronize: () -> (),
	desynchronize: () -> (),
}
