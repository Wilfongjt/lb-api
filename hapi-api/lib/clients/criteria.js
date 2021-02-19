// doesnt handle the xk yk variation

export class Criteria {
  constructor(chelate, metaKeys='pk sk tk xk yk') {
    //this.tablename='one';
    // no value
    if (!chelate){
      throw Error('Missing Criteria');
    }
    if (typeof(chelate) !== 'object') {
      throw Error('Must initialize Criteria with object.');
    }
    if ((!chelate.pk && !chelate.sk && !chelate.xk) ) {
      throw Error('Criteria is Missing Key');
    }
    if ((!chelate.sk && !chelate.tk && !chelate.yk) ) {
      throw Error('Criteria is Missing Key');
    }

    for (let key in chelate) {
      if (metaKeys.includes(key) ) {
        this[key] = chelate[key];
      }
    }
  }
}

export class CriteriaPK extends Criteria {
  constructor(chelate){
    super(chelate, 'pk sk');
    if ((!chelate.pk && !chelate.sk) ) {
      throw Error('Invalid Primary Key in CriteriaPK ');
    }
    if (!chelate.tk || !chelate.yk || !chelate.xk) {
      throw Error('Invalid Key in CriteriaPK ');
    }
  }
}
export class CriteriaSK extends Criteria {
  constructor(chelate){
    super(chelate, 'sk tk');
  }
}

export class CriteriaBest extends Criteria {
  constructor(chelate) {
    super(chelate, 'pk sk tk xk yk');

    if (this.pk) {
      if (this.tk) {
        delete this.tk;
      }
    }
    if (this.xk) {
      if (this.pk) {
        delete this.pk;
      }
      if (this.sk) {
        delete this.sk;
      }
      if (this.tk) {
        delete this.tk;
      }
    }

  }
}
