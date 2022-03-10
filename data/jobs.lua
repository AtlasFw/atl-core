-- All the jobs for the server.

Server.Jobs = {
  ['unemployed'] = {
    name = 'Unemployed',
    ranks = {
      [1] = {
        label = 'Find a job',
        paycheck = 10,
        taxes = 10
      }
    }
  },
  ['police'] = {
    name = 'Police',
    ranks = {
      [1] = {
        label = 'Cadet',
        paycheck = 20,
        taxes = 10
      },
      [2] = {
        label = 'Officer I',
        paycheck = 30,
        taxes = 10
      }
    }
  },
  ['ambulance'] = {
    name = 'Ambulance',
    ranks = {
      [1] = {
        label = 'EMS',
        paycheck = 90,
        taxes = 10
      },
      [2] = {
        name = 'Paramedic',
        paycheck = 100,
        taxes = 10
      }
    }
  }
}