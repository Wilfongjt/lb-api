
const Password = require('../../lib/password');

test('Generate password hash', () => {
  expect(Password.hash('secret_pass', 10)).toBeDefined();

  expect(Password.hash('secret_pass',10))
    .toEqual({
      salt:expect.any(String),
      hash:expect.any(String)});

  expect(Password.hash('secret_pass',16))
    .toEqual({
      isValid:expect.any(Boolean),
      message:expect.any(String)
    });

  expect(Password.hash('secret_pass',null))
  .toEqual({
    isValid:expect.any(Boolean),
    message:expect.any(String)
  });

  expect(Password.hash('secret_pass','10'))
  .toEqual({
    isValid:expect.any(Boolean),
    message:expect.any(String)
  });
});
