import React from 'react';
import {Redirect} from '@docusaurus/router';

export default function Home() {
    // Leitet jeden, der auf die Startseite kommt, direkt zu /docs/intro weiter
    return <Redirect to="/docs/intro"/>;
}