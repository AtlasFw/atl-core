const app = Vue.createApp({
	data() {
		return {
			characters: new Map(),
			activeMulticharacter: true
		}
	},
	methods: {
		getCharacter(id) {
			return this.characters.get(id)
		},
		setCharacter(id, character) {
			this.characters.set(id, character)
		},
	}
});

app.component('char-box', {
	template: `
	
	`,
	props: ['char'],
})

app.mount('#app')