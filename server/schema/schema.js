// DATA Shape
// {
//   "airline": "American",
//   "flightCode": "RREE0001",
//   "fromAirportCode": "MUA",
//   "toAirportCode": "LAX",
//   "departureDate": "2016-01-20T00:00:00",
//   "emptySeats": 0,
//   "price": 541,
//   "planeType": "Boeing 787"
// }
const graphql = require('graphql');
const axios = require('axios');
const apiUrl = `http://api:3000`
// const apiUrl = `http://flightsdemo.cloudhub.io`
const {
  GraphQLObjectType,
  GraphQLString,
  GraphQLList,
  GraphQLSchema
} = graphql;

const FlightType = new GraphQLObjectType({
  name: 'Flight',
  description: '...',

  fields: () => ({
    airline: { type: GraphQLString },
    flightCode: { type: GraphQLString },
    fromAirportCode: { type: GraphQLString },
    toAirportCode: { type: GraphQLString },
    departureDate: { type: GraphQLString },
    emptySeats: { type: GraphQLString },
    price: { type: GraphQLString },
    planeType: { type: GraphQLString }
  })
});

const RootQuery = new GraphQLObjectType({
  name: 'RootQueryType',
  description: '',

  fields: {
    flights: {
      type: new GraphQLList(FlightType),
      args: {
        flightCode: { type: GraphQLString },
        airline: { type: GraphQLString },
        toAirportCode: { type: GraphQLString },
        fromAirportCode: { type: GraphQLString }
      },
      resolve(parentValue, {flightCode, airline, toAirportCode, fromAirportCode}) {
        let airlineFetch;
        const keywordEndpointMap = {
          american: 'getAmericanFlights',
          united: 'getUnitedFlights',
          qantas: 'getQantasFlights',
          delta: 'getDeltaFlights'
        }
        if (airline) {
          airlineFetch = axios.get(`${apiUrl}/${keywordEndpointMap[airline]}`)
            .then(r => r.data);
        } else {
        //No airline filter
          const american = axios.get(`${apiUrl}/getAmericanFlights`).then(r => r.data);
          const united = axios.get(`${apiUrl}/getUnitedFlights`).then(r => r.data);
          const quantas = axios.get(`${apiUrl}/getQantasFlights`).then(r => r.data);
          const delta = axios.get(`${apiUrl}/getDeltaFlights`).then(r => r.data);

          airlineFetch = Promise.all([american, united, quantas, delta])
            .then(([a,b,c,d]) => {
              return [...a, ...b, ...c, ...d];
            });
        }
        if (fromAirportCode) {
          airlineFetch = airlineFetch.then(d => d.filter(d => t.fromAirportCode === fromAirportCode))
        }
        //Destination filtering
        if (toAirportCode) {
          airlineFetch = airlineFetch.then(d => d.filter(d => d.toAirportCode === toAirportCode));
        }
        if (flightCode) {
          airlineFetch = airlineFetch.then(d => d.filter(d => d.flightCode === flightCode));
        }

        // Departure Date sorting
        airlineFetch = airlineFetch.then(d => d.sort(((a,b) => {
          const keyA = new Date(a.departureDate);
          const keyB = new Date(b.departureDate);
          if (keyA < keyB) return -1;
          if (keyA > keyB) return 1;
          return 0;
        })));

        return airlineFetch;
      }
    }
  }
});

module.exports = new GraphQLSchema({
  query: RootQuery
});