const fetchNUI = async (cbname, data) => {
	const options = {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json; charset=UTF-8'
		},
		body: JSON.stringify(data)
	};
	const resp = await fetch(`https://atl-core/${cbname}`, options);
	return await resp.json();
}

const app = Vue.createApp({
	data() {
		return {
			multicharacter: {
				activated: false,
				charSelection: 'Choose a Slot',
				selected: null,
				action: null,
				chars: []
			},
		}
	},
	methods: {
		messageHandler(e) {
			switch (e.data.action) {
				case 'startMulticharacter':
					for (let i = 0; i < e.data.identity.MaxSlots; i++) {
						if (e.data.playerData[i]) {
							const test = {
								character_id: e.data.playerData[i].character_id,
								firstName: 'John',
								lastName: 'Doe',
								dob: '01/01/2000',
								sex: 'Male',
								accounts: {
									money: 1500,
									bank: 1500,
									black: 1500,
									tebex: 0
								},
								jobs: {
									jobName: 'Police',
									jobGrade: 'Chief',
									job2Name: 'Mechanic',
									job2Grade: 'Recruit'
								}
							}
							this.multicharacter.chars.push(test)
							continue;
						}

						if (i >= e.data.identity.AllowedSlots) {
							this.multicharacter.chars.push({
								character_id: 'blocked'
							})
							continue;
						}

						if (!e.data.playerData[i]) {
							this.multicharacter.chars.push({
								character_id: 'create'
							})
							continue;
						}
					}
					this.multicharacter.activated = true
					break;
				case 'endMulticharacter':
                    this.multicharacter.activated = false
                    this.multicharacter.chars.length = 0
					break;
			}
		},
		checkCharacter() {
			if (this.multicharacter.data === 'create') {
				fetchNUI('create_character').then((data) => {
                    if (data.done) {
                        this.clearData()
                    } else {
                        console.log('Error: Could not create character. Data was not received')
                    }
                })
			} else if (this.multicharacter.data !== null) {
				fetchNUI('select_character', {character_id: this.multicharacter.data}).then((data) => {
                    if (data.done) {
                        this.clearData()
                    } else {
                        console.log('Error: Could not select character. Data was not received')
                    }
                })
			}
		},
		deleteSelected(data) {
			fetchNUI('delete_character', {character_id: data}).then((data) => {
                if (data.done) {
                    this.clearData()
                } else {
                    console.log('Error: Could not delete character. Data was not received')
                }
            })
		},
        clearData() {
            this.multicharacter.activated = false
            this.multicharacter.data = null
            this.multicharacter.charSelection = 'Choose a Slot'
            this.multicharacter.chars.length = 0
            this.multicharacter.selected = null
        },
		setSelected(key) {
			const target = document.getElementById(`char_${key}`)
			if (this.$refs.creation.disabled) {
				this.$refs.creation.style.backgroundColor = '#113A57'
				this.$refs.creation.disabled = false
			}

			if (this.selected) {
				this.selected.classList.remove('ring-4', 'ring-sky-600')
				this.selected.classList.add('border-b-4', 'border-r-4')
				if (this.selected === target) {
					this.multicharacter.charSelection = 'Choose a Slot'
					this.selected = null
					return
				}
			}
			this.selected = target
			target.classList.add('ring-4', 'ring-sky-600')
			this.selected.classList.remove('border-b-4', 'border-r-4')
			switch (target.getAttribute('data-char-id')) {
				case 'create':
					this.multicharacter.charSelection = 'Create Character'
					this.multicharacter.data = 'create'
					break
				case 'blocked':
					target.classList.add('ring-4', 'ring-red-600')
					this.multicharacter.charSelection = 'Blocked Character'
					this.$refs.creation.style.backgroundColor = '#d52b2b'
					this.$refs.creation.disabled = true
					this.multicharacter.data = null
					return
				default:
					this.multicharacter.data = parseInt(target.getAttribute('data-char-id'))
					this.multicharacter.charSelection = 'Select Character'
					break
			}
			target.classList.add('ring-4', 'ring-sky-600')
		},
	},
	mounted() {
		console.log('mounted')
		window.addEventListener('message', this.messageHandler)
	},
	unmounted() {
		window.removeEventListener('message', this.messageHandler)
	},
});

app.component('char-box', {
	template: `
		<button :id="char_elem_id" :data-char-id="char_id " style="background-color: #1D2A39" class="flex flex-col justify-evenly items-center rounded-xl row-span-5 mb-8 mt-8 drop-shadow-md border-b-4 border-r-4 border-slate-600">
	    <info-box v-if="char_id !== 'create' && char_id !== 'blocked'" svg_path="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2" name1="First Name" name2="Last Name" name3="DOB" name4="Sex" :data1="char_data.firstName" :data2="char_data.lastName" :data3="char_data.dob" :data4="char_data.sex"></info-box>
	    <info-box v-if="char_id !== 'create' && char_id !== 'blocked'" svg_path="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" name1="Money" name2="Bank" name3="Black Money" name4="Coins" :data1="char_data.accounts.money" :data2="char_data.accounts.bank" :data3="char_data.accounts.black" :data4="char_data.accounts.tebex"></info-box>
	    <info-box v-if="char_id !== 'create' && char_id !== 'blocked'" svg_path="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" name1="Job Name" name2="Job Grade" name3="Job Two Name" name4="Job Two Grade" :data1="char_data.jobs.jobName" :data2="char_data.jobs.jobGrade" :data3="char_data.jobs.job2Name" :data4="char_data.jobs.job2Grade"></info-box>
	    <div v-if="char_id === 'create'" class="group flex flex-col items-center justify-center w-5/6 h-full">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-48 w-48 text-gray-200" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.3" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
				</svg>
				<span class="group-hover:underline font-spline-sans text-gray-200 text-xl font-semibold">Create a new character and start your new life. </span>
			</div>
			<div v-if="char_id === 'blocked'" class="group flex flex-col items-center justify-center w-5/6 h-full">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-48 w-48 text-gray-200" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.3" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
				</svg>
				<span class="group-hover:underline font-spline-sans text-gray-200 text-xl font-semibold">Ask for more character slots with administration.</span>
			</div>
			<button v-if="char_id !== 'create' && char_id !== 'blocked'" @click="$emit('delete-selected', char_id)" style="background-color: #113A57" class="group w-10 h-10 bg-slate-500 rounded grid place-items-center text-shadow-black drop-shadow-lg">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-200 group-hover:animate-pulse transform duration-200" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
				</svg>
			</button>
		</button>
	`,
	props: ['char_id', 'char_data', 'char_elem_id'],
})

app.component('info-box', {
	template: `
		<div class="group flex flex-row items-center  mt-6 w-5/6 h-32 bg-gray-100 rounded-xl drop-shadow-md">
				<div class="h-full w-1/4 flex items-center justify-center ring-0">
				  <div class="flex items-center justify-center bg-sky-300 w-3/4 h-3/4 rounded-lg">
				 		<svg xmlns="http://www.w3.org/2000/svg" class="z-10 h-8 w-8 text-indigo-900" fill="none" viewBox="0 0 24 24" stroke="currentColor">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="svg_path" />
						</svg>
					</div>
				</div>
				<div class="grid grid-cols-2 grid-rows-2 h-3/4 w-3/4 font-spline-sans">
					<div class="flex flex-col items-center justify-center bg-3 row-span-2">
						<span class="font-bold group-hover:underline">{{ name1 }}</span>
						<span class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150">{{ data1 }}</span>
					</div>
					<div class="flex flex-col items-center justify-center bg-3 row-span-2">
						<span class="font-bold group-hover:underline">{{ name2 }}</span>
						<span class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150">{{ data2 }}</span>
					</div>
					<div class="flex flex-col items-center justify-center bg-3 row-span-2">
						<span class="font-bold group-hover:underline">{{ name3 }}</span>
						<span class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150">{{ data3 }}</span>
					</div>
					<div class="flex flex-col items-center justify-center bg-3 row-span-2">
						<span class="font-bold group-hover:underline">{{ name4 }}</span>
						<span class="font-semibold text-gray-500 group-hover:text-gray-600 transform duration-150">{{ data4 }}</span>
					</div>
				</div>
		</div>
	`,
	props: ['data1', 'data2', 'data3', 'data4', 'name1', 'name2', 'name3', 'name4', 'svg_path']
})

app.mount('#app')