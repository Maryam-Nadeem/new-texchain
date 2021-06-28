import React, { Component } from "react";
import 'semantic-ui-css/semantic.min.css';
import { Button, Table ,Container} from 'semantic-ui-react';
import SuppHeader from '../components/Headers/SuppHeader';
import Supp_inv_form from '../components/Forms/Supp_inv_form';

class SuppInventory extends Component{

    render(){
        return(
            <div >
               <SuppHeader/>
               <Supp_inv_form/>

           </div>
        );
    }
   }

   export default SuppInventory;