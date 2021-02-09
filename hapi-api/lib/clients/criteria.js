
export class Criteria {
  constructor(chelate, metaKeys='pk sk tk') {
    //this.metaKeys = "active created form updated";

    //this.criteria= {};
    for (let key in chelate) {

      if (metaKeys.includes(key) ) {
        this[key] = chelate[key];
      }
    }
  }
  getCriteria() {
    return this.criteria;
  }
}
export class CriteriaPK extends Criteria {
  constructor(chelate){
    super(chelate, 'pk sk');
  }
}
export class CriteriaSK extends Criteria {
  constructor(chelate){
    super(chelate, 'sk tk');
  }
}
export class CriteriaBest extends Criteria {
  constructor(chelate){
    super(chelate, 'pk sk tk');
    if (this.pk) {
      if (this.tk) {
        delete this.tk;
      }
    }
  }

}
