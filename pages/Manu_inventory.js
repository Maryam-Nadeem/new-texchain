import React, { Component } from "react";
import 'semantic-ui-css/semantic.min.css';
import { Button, Table ,Container} from 'semantic-ui-react';
import ManuHeader from '../components/Headers/ManuHeader';
import Manu_inv_form from '../components/Forms/Manu_inv_form';

class ManufacturerPage1 extends Component{

 render(){
     return(
         <div >
            <ManuHeader/>
            <Manu_inv_form/>
        </div>
     );
 }
}

export default ManufacturerPage1;