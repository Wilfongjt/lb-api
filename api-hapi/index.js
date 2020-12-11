'use strict';

       const Hapi = require('@hapi/hapi');
       const Inert = require('@hapi/inert');
       const Vision = require('@hapi/vision');
       const HapiSwagger = require('hapi-swagger');

       const Pack = require('./package');
       const fs = require('fs');
       const util = require('util');

       // Convert fs.readFile, fs.writeFile into Promise version of same
       const readFile = util.promisify(fs.readFile);
       const writeFile = util.promisify(fs.writeFile);

       (async () => {
           const server = await new Hapi.Server({
               host: '0.0.0.0',
               port: 3001,
           });

           const swaggerOptions = {
               info: {
                       title: 'Test API Documentation',
                       version: Pack.version,
                   },
               };

           await server.register([
               Inert,
               Vision,
               {
                   plugin: HapiSwagger,
                   options: swaggerOptions
               }
           ]);

           try {
               await server.start();
               console.log('Server running at:', server.info.uri);
           } catch(err) {
               console.log(err);
           }

           //server.route(Routes);
           server.route({
               method: 'GET',
               path: '/books',
               options: {
               	   description: 'Get books list',
                   notes: 'Returns an array of books',
                   tags: ['api'],
                   handler: async (request, h) => {
                       const books = await readFile('./books.json', 'utf8');
                       return h.response(JSON.parse(books));
                   }
               }
           });

          server.route({
               method: 'POST',
               path: '/books',
               options: {
                 description: 'Add book to list',
                 notes: 'Returns an array of books',
                 tags: ['api'],
                   handler: async (request, h) => {
                       //const book = JSON.parse(request.payload);
                       const book = request.payload;
                       let books = await readFile('./books.json', 'utf8');
                       books = JSON.parse(books);
                       // setting id
                       book.id = books.length + 1;
                       books.push(book);
                       await writeFile('./books.json', JSON.stringify(books, null, 2), 'utf8');
                       return h.response(books).code(200);
                   }
               }
          });

          server.route({
              method: 'PUT',
              path: '/books/{id}',
              options: {
                description: 'Update book at key',
                notes: 'Returns an array of books',
                tags: ['api'],
                  handler: async (request, h) => {
                      // const updBook = JSON.parse(request.payload);
                      const updBook = request.payload;
                      const id = request.params.id;
                      let books = await readFile('./books.json', 'utf8');
                      books = JSON.parse(books);
                      // finding book by id and rewriting
                      books.forEach((book) => {
                          if (book.id == id) {
                              book.title = updBook.title;
                              book.author = updBook.author;
                          }
                      });
                      await writeFile('./books.json', JSON.stringify(books, null, 2), 'utf8');
                      return h.response(books).code(200);
                  }
              }
          });

          server.route({
             method: 'DELETE',
             path: '/books/{id}',
             options: {
               description: 'Delete a book at key from list',
               notes: 'Returns an array of books',
               tags: ['api'],
                 handler: async (request, h) => {
                     // const updBook = JSON.parse(request.payload);
                     const updBook = request.payload;

                     const id = request.params.id;
                     let books = await readFile('./books.json', 'utf8');
                     books = JSON.parse(books);
                     // rewriting the books array
                     books = books.filter(book => book.id != id);
                     await writeFile('./books.json', JSON.stringify(books, null, 2), 'utf8');
                     return h.response(books).code(200);
                 }
             }
         });

       })();
