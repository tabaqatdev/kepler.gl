// SPDX-License-Identifier: MIT
// Copyright contributors to the kepler.gl project

import React from 'react';
import styled from 'styled-components';
import {KEPLER_GL_WEBSITE} from '@kepler.gl/constants';

const LogoWrapper = styled.div`
  display: flex;
  align-items: center;
`;

interface KeplerGlLogoProps {
  appName?: string;
  version?: string | boolean;
  appWebsite?: string;
}

const KeplerGlLogo = ({
  appWebsite = KEPLER_GL_WEBSITE
}: KeplerGlLogoProps) => (
  <LogoWrapper className="side-panel-logo">
    <a target="_blank" rel="noopener noreferrer" href={appWebsite}>
      <img src="/logo.png" alt="Tabaqat" style={{height: '32px', display: 'block'}} />
    </a>
  </LogoWrapper>
);

export default KeplerGlLogo;
